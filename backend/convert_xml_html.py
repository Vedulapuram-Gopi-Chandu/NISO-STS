import os
import re
from lxml import etree
from pathlib import Path


def convert_xml_to_html(xml_path, xsl_path, image_prefix='', image_ext=''):

    if not os.path.exists(xml_path):
        raise FileNotFoundError(f"XML file not found: {xml_path}")
    
    if not os.path.exists(xsl_path):
        raise FileNotFoundError(f"XSL file not found: {xsl_path}")
    
    try:
        parser = etree.XMLParser(recover=True, remove_blank_text=True)

        xml_tree = etree.parse(xml_path, parser)
        
        xsl_tree = etree.parse(xsl_path, parser)
        transform = etree.XSLT(xsl_tree)

        html_tree = transform(
            xml_tree,
            image_path_prefix=etree.XSLT.strparam(image_prefix),
            image_file_extension=etree.XSLT.strparam(image_ext)
        )
        
        if transform.error_log:
    
            errors = "\n".join([str(error) for error in transform.error_log if error.level_name != 'INFO'])
            if errors:
                raise RuntimeError(f"XSL transformation warnings/errors:\n{errors}")

        html_content = etree.tostring(
            html_tree, 
            pretty_print=True, 
            encoding="unicode",
            method="html"
        )

        html_content = normalize_image_paths(html_content, image_prefix)
        
        return html_content
        
    except etree.XMLSyntaxError as e:
        raise RuntimeError(f"XML syntax error in XML or XSL file: {e}")
    except etree.XSLTParseError as e:
        raise RuntimeError(f"XSL stylesheet parse error: {e}")
    except etree.XSLTApplyError as e:
        raise RuntimeError(f"XSL transformation error: {e}")
    except Exception as e:
        raise RuntimeError(f"Unexpected error during XML-to-HTML conversion: {e}")


def normalize_image_paths(html_content, image_prefix):

    if not image_prefix:
        return html_content
    
    prefix = image_prefix.rstrip('/')
    
    patterns = [
        r'src="figures/',
        r'src="images/',
        r'src="graphics/',
        r'src="./figures/',
        r'src="./images/',
        r'src="./graphics/',
        r'src="../figures/',
        r'src="../images/',
        r'src="../graphics/',
    ]
    
    for pattern in patterns:
        html_content = re.sub(
            pattern,
            f'src="{prefix}/',
            html_content
        )
    
    html_content = re.sub(
        r'src="(?!http|/|data:)([^/"]+\.(png|jpg|jpeg|gif|svg|bmp|webp))"',
        f'src="{prefix}/\\1"',
        html_content,
        flags=re.IGNORECASE
    )
    
    return html_content


def validate_xml_file(xml_path, max_size_mb=50):

    file_path = Path(xml_path)
    
    if not file_path.exists():
        raise ValueError(f"XML file does not exist: {xml_path}")
    
    if not file_path.is_file():
        raise ValueError(f"Path is not a file: {xml_path}")
    
    file_size_mb = file_path.stat().st_size / (1024 * 1024)
    if file_size_mb > max_size_mb:
        raise ValueError(f"XML file too large: {file_size_mb:.2f}MB (max: {max_size_mb}MB)")
    
    try:
        with open(xml_path, 'rb') as f:
            header = f.read(1024)
            if b'<?xml' not in header and b'<' not in header[:100]:
                raise ValueError("File does not appear to be valid XML")
    except Exception as e:
        raise ValueError(f"Cannot read XML file: {e}")
    
    return True