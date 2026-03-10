from flask import Flask, request, send_from_directory, jsonify, redirect
from werkzeug.utils import secure_filename
from convert_xml_html import convert_xml_to_html

import os
import zipfile
import tempfile
import shutil
from pathlib import Path
from datetime import datetime

app = Flask(__name__)

XSL_PATH = "NISO_TO_HTML.xsl"
SCSS_PATH = "niso-to-html.scss"
CONVERSIONS_FOLDER = "conversions"
FRONTEND_URL = os.environ.get("FRONTEND_URL", "http://localhost:5173")
MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB
ALLOWED_EXTENSIONS = {"zip"}
ALLOWED_IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".svg", ".bmp", ".webp"}

app.config["MAX_CONTENT_LENGTH"] = MAX_FILE_SIZE


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def build_conversion_url(conversion_id, html_filename):
    return f"{request.host_url.rstrip('/')}/conversions/{conversion_id}/{html_filename}"


@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = FRONTEND_URL
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    return response


@app.route("/")
def home():
    return redirect(FRONTEND_URL)


@app.route("/api/conversions", methods=["GET"])
def list_conversions():
    if not os.path.exists(CONVERSIONS_FOLDER):
        return jsonify({"conversions": []})

    saved_conversions = sorted(
        [d for d in os.listdir(CONVERSIONS_FOLDER) if os.path.isdir(os.path.join(CONVERSIONS_FOLDER, d))],
        reverse=True,
    )

    results = []
    for item in saved_conversions:
        html_name = f"{item.split('_', 2)[-1]}.html"
        html_path = Path(CONVERSIONS_FOLDER) / item / html_name
        if html_path.exists():
            results.append(
                {
                    "id": item,
                    "html_filename": html_name,
                    "url": build_conversion_url(item, html_name),
                }
            )

    return jsonify({"conversions": results})


@app.route("/api/convert", methods=["POST", "OPTIONS"])
def convert():
    if request.method == "OPTIONS":
        return ("", 204)

    if "file" not in request.files or not request.files["file"].filename:
        return jsonify({"error": "No file selected. Please choose a ZIP file."}), 400

    zip_file = request.files["file"]

    if not allowed_file(zip_file.filename):
        return jsonify({"error": "Invalid file type. Only ZIP files (.zip) are allowed."}), 400

    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    safe_zip_name = secure_filename(Path(zip_file.filename).stem)
    unique_folder_name = f"{timestamp}_{safe_zip_name}"
    conversion_path = Path(CONVERSIONS_FOLDER) / unique_folder_name

    with tempfile.TemporaryDirectory() as temp_dir:
        try:
            extract_dir = Path(temp_dir)

            zip_path = extract_dir / secure_filename(zip_file.filename)
            zip_file.save(zip_path)

            with zipfile.ZipFile(zip_path, "r") as zip_ref:
                zip_ref.extractall(extract_dir)

            xml_files = list(extract_dir.glob("**/*.xml"))
            if not xml_files:
                raise RuntimeError("No XML file found in the ZIP archive.")
            if len(xml_files) > 1:
                raise RuntimeError(f"Multiple XML files ({len(xml_files)}) found. Only one is allowed.")
            xml_path = xml_files[0]

            conversion_path.mkdir(parents=True)

            for ext in ALLOWED_IMAGE_EXTENSIONS:
                for img_path in extract_dir.glob(f"**/*{ext}"):
                    shutil.copy2(img_path, conversion_path / secure_filename(img_path.name))

            html_content = convert_xml_to_html(
                str(xml_path),
                XSL_PATH,
                image_prefix="",
                image_ext=".png",
            )

            html_filename = f"{safe_zip_name}.html"
            html_file_path = conversion_path / html_filename
            with html_file_path.open("w", encoding="utf-8") as f:
                f.write(html_content)

            if not os.path.exists(SCSS_PATH):
                raise RuntimeError(f"SCSS file not found: {SCSS_PATH}")
            shutil.copy2(SCSS_PATH, conversion_path / Path(SCSS_PATH).name)

            return jsonify(
                {
                    "conversion_id": unique_folder_name,
                    "html_filename": html_filename,
                    "url": build_conversion_url(unique_folder_name, html_filename),
                }
            )

        except Exception as e:
            if os.path.exists(conversion_path):
                shutil.rmtree(conversion_path)
            app.logger.error(f"Error during conversion: {e}")
            return jsonify({"error": f"Conversion failed: {e}"}), 500


@app.route("/conversions/<path:conversion_id>/<path:filename>")
def serve_conversion_file(conversion_id, filename):
    safe_conversion_id = secure_filename(conversion_id)
    directory = Path(CONVERSIONS_FOLDER).resolve() / safe_conversion_id

    if not directory.is_dir():
        return jsonify({"error": "Conversion not found."}), 404

    return send_from_directory(str(directory), filename)


@app.errorhandler(413)
def request_entity_too_large(error):
    return jsonify({"error": f"File is too large. Maximum size is {MAX_FILE_SIZE / 1024 / 1024:.0f}MB."}), 413


if __name__ == "__main__":
    os.makedirs(CONVERSIONS_FOLDER, exist_ok=True)
    if not os.path.exists(XSL_PATH):
        print(f"WARNING: XSL file '{XSL_PATH}' not found. Application will fail on conversion.")
    if not os.path.exists(SCSS_PATH):
        print(f"WARNING: SCSS file '{SCSS_PATH}' not found. Converted HTML may not be styled.")
    app.run(debug=True, host="0.0.0.0", port=5000)
