# XML to HTML Converter

This is a Flask web application designed to convert XML files into styled HTML pages using an XSLT stylesheet. The application is built to handle `.zip` archives that contain a primary XML document along with its associated image assets.


## About The Project

The goal of this project is to offer a simple, web-based tool for transforming structured XML documents into human-readable HTML. By uploading a single `.zip` file, users can process an XML file and its dependent images, with the final output being a styled HTML page that is stored and can be revisited later.

This solves the common problem of needing to view formatted XML content without manual conversion or complex local setups.

### Key Features

*   **Simple Web Interface**: An intuitive drag-and-drop or file-select UI for uploading archives.
*   **ZIP Archive Processing**: Accepts a `.zip` file as the standard input format, simplifying the bundling of XML and image files.
*   **Dynamic XSLT Transformation**: Leverages the powerful `lxml` library to apply a server-side XSLT stylesheet (`NISO_TO_HTML.xsl`) to the input XML.
*   **Image Asset Handling**: Automatically copies image files from the archive to a publicly accessible directory for the generated HTML.
*   **Persistent Conversion History**: Each successful conversion is saved in a unique, timestamped directory, with a list of past conversions available on the homepage for easy access.
*   **Robust Error Handling**: Provides clear user feedback for common issues such as invalid file types, missing XML files, oversized files, and transformation errors.

## Getting Started

Follow these steps to get a local copy of the application up and running.

### Prerequisites

*   Python 3.7+
*   `pip` (Python package installer)

### Installation

1.  **Create and Activate a Virtual Environment** (Recommended)
    ```sh
    # For macOS/Linux
    python3 -m venv venv
    source venv/bin/activate

    # For Windows
    py -m venv venv
    .\venv\Scripts\activate
    ```

2.  **Install Dependencies**
    Install all required Python packages from the `requirements.txt` file.
    ```sh
    pip install -r requirements.txt
    ```

3.  **Add the XSLT Stylesheet**
    This application requires an XSLT file named `NISO_TO_HTML.xsl` to perform the transformation. Place this file in the root directory of the project. The application will fail without it.

## Usage

1.  **Run the Flask Application**
    From the project's root directory, run the following command:
    ```sh
    flask run
    ```
    For development mode, which provides live reloading and an interactive debugger, you can also run:
    ```sh
    python app.py
    ```

2.  **Access the Application**
    Open your web browser and navigate to: `http://127.0.0.1:5000`

3.  **Upload a ZIP File**
    *   Click the file input area and select a `.zip` archive for conversion.
    *   The ZIP file **must** contain:
        *   Exactly one `.xml` file.
        *   (Optional) Any image files (`.png`, `.jpg`, `.svg`, etc.) that are referenced within the XML.
    *   Click the "Convert and View" button to start the process.

4.  **View the Result**
    Upon successful conversion, you will be automatically redirected to the newly generated HTML page.

5.  **Access Past Conversions**
    The homepage will display a list of all previously successful conversions, allowing you to view them again at any time.

## Project Structure

.
├── app.py                    # Main Flask application logic and routes
├── convert_xml_html.py       # Core XML-to-HTML conversion and validation functions
├── requirements.txt          # List of Python dependencies for pip
├── NISO_TO_HTML.xsl          # (Required) XSLT stylesheet for the transformation
│
├── conversions/              # Auto-generated folder to store conversion results
│ └── 2025-10-22_12-30-00_my-document/
│ ├── my-document.html
│ └── image1.png
│
└── static/                   # Optional folder for static assets like CSS or favicons
└── favicon.ico

## How It Works

### File Upload and Extraction

The Flask application (`app.py`) defines a `/convert` endpoint that accepts a POST request with the uploaded `.zip` file. It performs several checks:
1.  Verifies that the file is a `.zip` archive and does not exceed the maximum allowed size (50MB).
2.  Creates a unique, timestamped directory under the `conversions/` folder to store the output.
3.  Extracts the contents of the zip file into a temporary directory.

### XSLT Transformation

The core conversion logic resides in `convert_xml_html.py`:
1.  It finds the single `.xml` file within the extracted contents.
2.  It uses the `lxml` library to parse both the XML input file and the `NISO_TO_HTML.xsl` stylesheet.
3.  An `XSLT` object is created from the stylesheet, which is then applied to the XML tree. Parameters like image paths can be passed into the stylesheet during this process.
4.  The resulting transformed tree is serialized into an HTML string.

### Serving Content

- After the HTML content is generated, it is saved as an `.html` file inside the unique conversion directory.
- Any image files found in the original zip are copied into the same directory, ensuring that relative image links in the HTML work correctly.
- The user is then redirected to a specific URL that serves the generated HTML file and its associated assets from the corresponding `conversions/` subdirectory.