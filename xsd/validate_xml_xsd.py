#!/usr/bin/env python3
"""
validate.py

Tiện ích nhỏ để kiểm tra tính hợp lệ giữa một file XML và XSD.

Ưu tiên dùng `xmlschema` (thông tin lỗi chi tiết). Nếu không có sẽ thử `lxml`.

Sử dụng:
  python validate.py --xml thuvien.xml --xsd thuvien.xsd

Trả về mã thoát 0 khi hợp lệ, 2 khi không hợp lệ, 1 khi lỗi môi trường.
"""
from __future__ import annotations

import argparse
import os
import sys
from typing import Optional


def validate_with_xmlschema(xml_path: str, xsd_path: str) -> bool:
    import xmlschema

    try:
        schema = xmlschema.XMLSchema(xsd_path)
    except Exception as e:
        print(f"[xmlschema] Lỗi khi tải XSD: {e}")
        raise

    try:
        valid = schema.is_valid(xml_path)
        if valid:
            print("[xmlschema] XML hợp lệ với XSD.")
            return True
        else:
            print("[xmlschema] XML KHÔNG hợp lệ. Liệt kê lỗi:")
            for err in schema.iter_errors(xml_path):
                print(f"- {err}")
            return False
    except Exception as e:
        print(f"[xmlschema] Lỗi khi kiểm tra XML: {e}")
        raise


def validate_with_lxml(xml_path: str, xsd_path: str) -> bool:
    from lxml import etree

    try:
        xml_doc = etree.parse(xml_path)
    except Exception as e:
        print(f"[lxml] Lỗi khi phân tích XML: {e}")
        raise

    try:
        with open(xsd_path, 'rb') as f:
            schema_root = etree.parse(f)
        schema = etree.XMLSchema(schema_root)
    except Exception as e:
        print(f"[lxml] Lỗi khi tải XSD: {e}")
        raise

    valid = schema.validate(xml_doc)
    if valid:
        print("[lxml] XML hợp lệ với XSD.")
        return True
    else:
        print("[lxml] XML KHÔNG hợp lệ. Lỗi chi tiết (error_log):")
        for entry in schema.error_log:
            print(f"- line {entry.line}, column {entry.column}: {entry.message}")
        return False


def main(xml_path: Optional[str] = None, xsd_path: Optional[str] = None) -> int:
    parser = argparse.ArgumentParser(description="Validate an XML file against an XSD.")
    parser.add_argument("--xml", default=xml_path, help="Path to XML file")
    parser.add_argument("--xsd", default=xsd_path, help="Path to XSD file")
    args = parser.parse_args()

    xml_file = args.xml
    xsd_file = args.xsd

    if not xml_file or not xsd_file:
        print("Vui lòng cung cấp cả --xml và --xsd (hoặc để mặc định trong code).")
        return 1

    # Normalize paths
    xml_file = os.path.abspath(xml_file)
    xsd_file = os.path.abspath(xsd_file)

    if not os.path.exists(xml_file):
        print(f"Không tìm thấy file XML: {xml_file}")
        return 1
    if not os.path.exists(xsd_file):
        print(f"Không tìm thấy file XSD: {xsd_file}")
        return 1

    # Try xmlschema first, then lxml. If neither available, instruct how to install.
    tried = []
    try:
        import xmlschema  # type: ignore
    except Exception:
        xmlschema = None

    try:
        from lxml import etree  # type: ignore
    except Exception:
        etree = None

    if xmlschema:
        try:
            ok = validate_with_xmlschema(xml_file, xsd_file)
            return 0 if ok else 2
        except Exception:
            print("[xmlschema] Đã xảy ra lỗi khi kiểm tra bằng xmlschema. Thử lxml (nếu có)...")
            tried.append('xmlschema')

    if etree:
        try:
            ok = validate_with_lxml(xml_file, xsd_file)
            return 0 if ok else 2
        except Exception:
            print("[lxml] Đã xảy ra lỗi khi kiểm tra bằng lxml.")
            tried.append('lxml')

    print("Không có thư viện thích hợp để kiểm tra. Cài một trong các gói sau:")
    print("  pip install xmlschema")
    print("  hoặc")
    print("  pip install lxml")
    return 1


if __name__ == '__main__':
    # Provide sensible defaults relative to this script file
    base_dir = os.path.dirname(__file__)
    default_xml = os.path.join(base_dir, 'thuvien.xml')
    default_xsd = os.path.join(base_dir, 'thuvien.xsd')

    # When executed directly without args, argparse will pick up defaults from main's signature only if None,
    # so we call main with defaults as CLI fallbacks by manipulating sys.argv when empty of flags.
    # Simpler: set environment defaults via passing to main() through argparse default mechanism.
    # We'll emulate by setting default values in sys.argv only if the user didn't provide any --xml/--xsd.
    provided = any(a.startswith('--xml') or a.startswith('--xsd') for a in sys.argv[1:])
    if not provided:
        sys.argv += ['--xml', default_xml, '--xsd', default_xsd]

    exit_code = main()
    sys.exit(exit_code)
