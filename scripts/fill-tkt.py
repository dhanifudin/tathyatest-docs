#!/usr/bin/env python3
"""Isi borang resmi TKT software (docs/pengukuran-tkt.zip) dengan data TathyaTest.

Usage: python3 -I scripts/fill-tkt.py docs/pengukuran-tkt.zip supplement/assets/tkt-software.xlsx

Sheet XML diedit langsung (bukan openpyxl) agar gambar/kontrol form borang tetap
utuh. Hasilnya di-commit sebagai sumber yang dapat disunting; skrip ini hanya
dijalankan sekali lewat `make tkt-fill`.
"""
import re
import sys
import zipfile
from xml.sax.saxutils import escape

SRC_NAME = "5. PENGUKURAN TKT SOFTWARE.xlsx"

PROFIL = {  # sheet1: PROFIL PENELITI
    5: "Dian Hanifudin Subhi, S.Kom., M.Kom.",
    6: "PERGURUAN TINGGI",
    7: "Politeknik Negeri Malang",
    8: "Ketua Peneliti (Lektor)",
    9: "198806102019031018",
    10: "0010068807",
    11: "Jurusan Teknologi Informasi, Politeknik Negeri Malang, Jl. Soekarno Hatta No. 9, Jatimulyo, Lowokwaru",
    12: "Malang",
    13: "082230743546",
    14: "dhanifudin@polinema.ac.id",
}

IDENTITAS = {  # sheet2: IDENTITAS UMUM
    5: "Desain dan Implementasi TathyaTest: Test Case Generator Otomatis untuk Pengujian Fungsional Aplikasi Web",
    6: "TathyaTest: Test Case Generator Otomatis",
    7: "TIK",
    8: "Test case generator otomatis yang melakukan crawling DOM ter-render dengan Playwright, membangun model elemen dan matriks akses per peran, lalu menghasilkan dan mengeksekusi test case fungsional.",
    9: "Selesai",
    10: "Naskah artikel JUTI (belum diajukan)",
    12: "DIPA Politeknik Negeri Malang",
    13: "Penelitian Reguler Kompetisi",
    14: "Rp 9.000.000",
    16: "Dian Hanifudin Subhi, S.Kom., M.Kom.",
    17: "082230743546",
    18: "dhanifudin@polinema.ac.id",
    19: "Jurusan Teknologi Informasi, Politeknik Negeri Malang, Jl. Soekarno Hatta No. 9, Jatimulyo, Lowokwaru, Malang",
    20: "Politeknik Negeri Malang",
}

# sheet3: PENGUKURAN TKT SOFTWARE -- skor per indikator (baris = baris di xlsx).
# TKT 1-4 terpenuhi; TKT 5 belum (belum diintegrasikan dengan sistem operasional
# eksisting), sehingga TKT yang dicapai = 4.
SKOR = {
    5: 1, 6: 1, 7: 1,
    11: 1, 12: 1, 13: 1,
    17: 1, 18: 1, 19: 1,
    23: 1, 24: 0.8, 25: 0.8, 26: 1, 27: 1,
    31: 0.4, 32: 0.6, 33: 0.6, 34: 0.4, 35: 0.6, 36: 0.4,
    40: 0, 41: 0,
    45: 0, 46: 0,
    50: 0, 51: 0, 52: 0,
    56: 0, 57: 0, 58: 0, 59: 0, 60: 0, 61: 0,
}


def set_cell(xml, ref, value):
    """Ganti isi sel `ref` (mempertahankan atribut gaya s=)."""
    pat = re.compile(r'<c r="%s"((?: [\w:]+="[^"]*")*)\s*(?:/>|>.*?</c>)' % ref, re.S)
    m = pat.search(xml)
    if not m:
        raise SystemExit(f"cell {ref} not found")
    attrs = re.sub(r' t="[^"]*"', "", m.group(1))
    if isinstance(value, str):
        new = f'<c r="{ref}"{attrs} t="inlineStr"><is><t>{escape(value)}</t></is></c>'
    else:
        new = f'<c r="{ref}"{attrs}><v>{value}</v></c>'
    return xml[: m.start()] + new + xml[m.end():]


def strip_cached(xml):
    """Buang nilai cache rumus supaya dihitung ulang saat dibuka."""
    return re.sub(r"(<f[^>]*?(?:/>|>[^<]*</f>))<v>[^<]*</v>", r"\1", xml)


# Baris dengan teks panjang: (sheet, baris) -> tinggi baris (pt); selnya diberi wrap.
TALL = {
    "xl/worksheets/sheet1.xml": {11: 30},
    "xl/worksheets/sheet2.xml": {5: 45, 8: 60, 10: 30, 19: 30},
}
TANGGAL_UKUR = "12-10-2026"  # sheet4 (RINGKASAN) M21
PRINT_AREAS = ["'PROFIL PENELITI'!$A$1:$F$15", "'IDENTITAS UMUM'!$A$1:$F$21", "'PENGUKURAN TKT SOFTWARE'!$A$1:$I$62", "RINGKASAN!$F$2:$X$45"]


def add_wrap_styles(xml):
    """Tambah 3 gaya (id 180-182) = gaya isian 175/176/177 + wrap teks."""
    m = re.search(r'<cellXfs count="(\d+)">(.*?)</cellXfs>', xml, re.S)
    xfs = re.findall(r'<xf [^>]*?(?:/>|>.*?</xf>)', m.group(2), re.S)
    new = []
    for i in (175, 176, 177):
        x = xfs[i].replace('applyProtection="1">', 'applyAlignment="1" applyProtection="1"><alignment vertical="center" wrapText="1"/>', 1)
        new.append(x)
    body = m.group(2) + "".join(new)
    return xml[: m.start()] + f'<cellXfs count="{int(m.group(1)) + 3}">{body}</cellXfs>' + xml[m.end():]


def set_row_height(xml, row, ht):
    pat = re.compile(r'<row r="%d"((?: [\w:]+="[^"]*")*)>' % row)
    m = pat.search(xml)
    attrs = re.sub(r' (ht|customHeight)="[^"]*"', "", m.group(1))
    return xml[: m.start()] + f'<row r="{row}"{attrs} ht="{ht}" customHeight="1">' + xml[m.end():]


def wrap_cell(xml, ref):
    m = re.search(r'<c r="%s" s="(\d+)"' % ref, xml)
    new = {175: 180, 176: 181, 177: 182}.get(int(m.group(1)))
    if new is None:
        return xml
    return xml[: m.start()] + f'<c r="{ref}" s="{new}"' + xml[m.end():]


def fit_to_page(xml):
    if not re.search(r"<sheetPr[ >/]", xml):
        xml = xml.replace("<dimension", '<sheetPr><pageSetUpPr fitToPage="1"/></sheetPr><dimension', 1)
    xml = re.sub(r'<sheetPr codeName="([^"]*)"/>', r'<sheetPr codeName="\1"><pageSetUpPr fitToPage="1"/></sheetPr>', xml, count=1)
    xml = re.sub(r'<pageSetup[^>]*/>', '', xml)
    return re.sub(r'(<pageMargins[^>]*/>)', r'\1<pageSetup paperSize="9" orientation="portrait" fitToWidth="1" fitToHeight="0"/>', xml, count=1)


def main(zip_path, out_path):
    src = zipfile.ZipFile(zip_path).read(SRC_NAME)
    import io

    zin = zipfile.ZipFile(io.BytesIO(src))
    edits = {
        "xl/worksheets/sheet1.xml": {f"E{r}": v for r, v in PROFIL.items()},
        "xl/worksheets/sheet2.xml": {f"E{r}": v for r, v in IDENTITAS.items()},
        "xl/worksheets/sheet3.xml": {f"E{r}": v for r, v in SKOR.items()},
    }
    with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename in edits:
                xml = data.decode("utf-8")
                for ref, v in edits[item.filename].items():
                    xml = set_cell(xml, ref, v)
                for row, ht in TALL.get(item.filename, {}).items():
                    xml = wrap_cell(set_row_height(xml, row, ht), f"E{row}")
                # Bug borang resmi: H50 (nilai TKT 8) merujuk O53 (kosong) -> #N/A.
                xml = xml.replace("LOOKUP(O53,", "LOOKUP(E53,")
                data = fit_to_page(strip_cached(xml)).encode("utf-8")
            elif item.filename == "xl/styles.xml":
                data = add_wrap_styles(data.decode("utf-8")).encode("utf-8")
            elif item.filename == "xl/worksheets/sheet4.xml":
                xml = set_cell(data.decode("utf-8"), "M21", TANGGAL_UKUR)
                data = fit_to_page(strip_cached(xml)).encode("utf-8")
            elif item.filename == "xl/workbook.xml":
                xml = data.decode("utf-8")
                xml = xml.replace('<calcPr calcId="152511"/>', '<calcPr calcId="152511" fullCalcOnLoad="1"/>')
                names = "".join(
                    f'<definedName name="_xlnm.Print_Area" localSheetId="{i}">{a}</definedName>'
                    for i, a in enumerate(PRINT_AREAS)
                )
                xml = xml.replace("<calcPr", f"<definedNames>{names}</definedNames><calcPr", 1)
                data = xml.encode("utf-8")
            zout.writestr(item, data)


if __name__ == "__main__":
    main(*sys.argv[1:3])
