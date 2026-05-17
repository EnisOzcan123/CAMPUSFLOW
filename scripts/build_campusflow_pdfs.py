from pathlib import Path
import re

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    PageTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
    PageBreak,
)


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "teslim_dokumanlari"

FONT = "/System/Library/Fonts/Supplemental/Arial.ttf"
FONT_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
pdfmetrics.registerFont(TTFont("CampusArial", FONT))
pdfmetrics.registerFont(TTFont("CampusArial-Bold", FONT_BOLD))

INK = colors.HexColor("#182026")
BLUE = colors.HexColor("#315F8C")
GREEN = colors.HexColor("#2F6F5E")
GOLD = colors.HexColor("#B7791F")
MUTED = colors.HexColor("#66717C")
LIGHT = colors.HexColor("#F5F8FB")
LINE = colors.HexColor("#DDE5EC")
WHITE = colors.white


def styles():
    s = getSampleStyleSheet()
    s.add(ParagraphStyle("CoverKicker", fontName="CampusArial-Bold", fontSize=10, textColor=GOLD, leading=13, spaceAfter=10))
    s.add(ParagraphStyle("CoverTitle", fontName="CampusArial-Bold", fontSize=27, textColor=WHITE, leading=32, spaceAfter=10))
    s.add(ParagraphStyle("CoverSub", fontName="CampusArial", fontSize=12.5, textColor=colors.HexColor("#D8E2EA"), leading=17, spaceAfter=10))
    s.add(ParagraphStyle("CoverMeta", fontName="CampusArial-Bold", fontSize=9.5, textColor=colors.HexColor("#D8E2EA"), leading=13))
    s.add(ParagraphStyle("H1x", fontName="CampusArial-Bold", fontSize=16, textColor=BLUE, leading=20, spaceBefore=13, spaceAfter=7))
    s.add(ParagraphStyle("H2x", fontName="CampusArial-Bold", fontSize=13, textColor=GREEN, leading=17, spaceBefore=10, spaceAfter=5))
    s.add(ParagraphStyle("Bodyx", fontName="CampusArial", fontSize=10.4, textColor=INK, leading=14, spaceAfter=6))
    s.add(ParagraphStyle("Bulletx", fontName="CampusArial", fontSize=10.2, textColor=INK, leftIndent=18, firstLineIndent=-10, leading=13.5, spaceAfter=4))
    s.add(ParagraphStyle("CalloutTitle", fontName="CampusArial-Bold", fontSize=11, textColor=GREEN, leading=14, spaceAfter=3))
    s.add(ParagraphStyle("CalloutBody", fontName="CampusArial", fontSize=10.2, textColor=INK, leading=14))
    return s


def on_page(canvas, doc, label):
    canvas.saveState()
    canvas.setFont("CampusArial", 8)
    canvas.setFillColor(MUTED)
    canvas.drawRightString(7.5 * inch, 10.35 * inch, label)
    canvas.drawCentredString(4.25 * inch, 0.48 * inch, f"CampusFlow | Web Programlama Dersi | Sayfa {doc.page}")
    canvas.restoreState()


def make_doc(path, label):
    doc = BaseDocTemplate(
        str(path),
        pagesize=letter,
        rightMargin=0.85 * inch,
        leftMargin=0.85 * inch,
        topMargin=0.85 * inch,
        bottomMargin=0.75 * inch,
    )
    frame = Frame(doc.leftMargin, doc.bottomMargin, doc.width, doc.height, id="normal")
    doc.addPageTemplates([PageTemplate(id="main", frames=[frame], onPage=lambda c, d: on_page(c, d, label))])
    return doc


def cover_block(story, st, report_type, title, subtitle, meta):
    table = Table(
        [
            [Paragraph(report_type.upper(), st["CoverKicker"])],
            [Paragraph(title, st["CoverTitle"])],
            [Paragraph(subtitle, st["CoverSub"])],
            [Paragraph(meta, st["CoverMeta"])],
        ],
        colWidths=[6.55 * inch],
    )
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), INK),
        ("BOX", (0, 0), (-1, -1), 1, INK),
        ("LEFTPADDING", (0, 0), (-1, -1), 24),
        ("RIGHTPADDING", (0, 0), (-1, -1), 24),
        ("TOPPADDING", (0, 0), (-1, -1), 26),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 26),
    ]))
    story.append(table)
    story.append(Spacer(1, 16))


def callout(story, st, title, body):
    table = Table([[Paragraph(title, st["CalloutTitle"]), Paragraph(body, st["CalloutBody"])]], colWidths=[1.35 * inch, 5.05 * inch])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#EEF5F2")),
        ("BOX", (0, 0), (-1, -1), 0.8, GREEN),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 12),
        ("RIGHTPADDING", (0, 0), (-1, -1), 12),
        ("TOPPADDING", (0, 0), (-1, -1), 10),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
    ]))
    story.append(table)
    story.append(Spacer(1, 10))


def clean_inline(text):
    text = text.replace("`", "")
    text = re.sub(r"\*\*(.*?)\*\*", r"<b>\1</b>", text)
    return text


def flush_table(story, st, lines):
    rows = []
    for line in lines:
        cells = [clean_inline(c.strip()) for c in line.strip().strip("|").split("|")]
        if all(re.fullmatch(r":?-{3,}:?", c or "") for c in cells):
            continue
        rows.append([Paragraph(c, st["Bodyx"]) for c in cells])
    if not rows:
        return
    col_count = len(rows[0])
    widths = [1.5 * inch, 4.9 * inch] if col_count == 2 else [6.4 * inch / col_count] * col_count
    table = Table(rows, colWidths=widths, repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), LIGHT),
        ("TEXTCOLOR", (0, 0), (-1, 0), INK),
        ("GRID", (0, 0), (-1, -1), 0.45, LINE),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("LEFTPADDING", (0, 0), (-1, -1), 8),
        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    story.append(table)
    story.append(Spacer(1, 8))


def add_markdown(story, st, text):
    table_lines = []
    skipped_title = False
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            if table_lines:
                flush_table(story, st, table_lines)
                table_lines = []
            continue
        if line.startswith("|"):
            table_lines.append(line)
            continue
        if table_lines:
            flush_table(story, st, table_lines)
            table_lines = []
        if line.startswith("# "):
            if not skipped_title:
                skipped_title = True
                continue
            story.append(Paragraph(clean_inline(line[2:]), st["H1x"]))
        elif line.startswith("## "):
            story.append(Paragraph(clean_inline(line[3:]), st["H1x"]))
        elif line.startswith("### "):
            story.append(Paragraph(clean_inline(line[4:]), st["H2x"]))
        elif line.startswith("- "):
            story.append(Paragraph("• " + clean_inline(line[2:]), st["Bulletx"]))
        elif re.match(r"^\d+\. ", line):
            story.append(Paragraph(clean_inline(line), st["Bulletx"]))
        elif line.startswith("> "):
            callout(story, st, "Not", clean_inline(line[2:]))
        else:
            story.append(Paragraph(clean_inline(line), st["Bodyx"]))
    if table_lines:
        flush_table(story, st, table_lines)


def build_pdf(md_name, output_name, label, report_type, title, subtitle, meta, summary):
    st = styles()
    path = OUT / output_name
    doc = make_doc(path, label)
    story = []
    cover_block(story, st, report_type, title, subtitle, meta)
    callout(story, st, "Kısa özet", summary)
    add_markdown(story, st, (ROOT / md_name).read_text(encoding="utf-8"))
    doc.build(story)
    return path


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    print(build_pdf(
        "SISTEM_ANLATISI.md",
        "CampusFlow_Sistem_Anlatisi.pdf",
        "CampusFlow Sistem Anlatısı",
        "Sistem Rehberi",
        "CampusFlow Sistem Anlatısı",
        "Kampüs mekanları, etkinlikler, harita, hava durumu ve bilet akışının sade açıklaması.",
        "Arkadaşına / ekip üyesine gönderilecek okunabilir sistem özeti",
        "CampusFlow, öğrencinin kampüste yer bulma, etkinlik takip etme, hava durumuna göre karar verme ve bilet alma ihtiyaçlarını tek sistemde toplar.",
    ))
    print(build_pdf(
        "PROJE_RAPORU.md",
        "CampusFlow_Proje_Raporu.pdf",
        "CampusFlow Proje Raporu",
        "Dönem Projesi Raporu",
        "CampusFlow Proje Raporu",
        "Web Programlama Dersi dönem projesi için kısa, açık ve yönergeye uygun rapor.",
        "Yapay zeka kullanımı: %60 ekip geliştirmesi, %40 destek",
        "Bu rapor proje konusu, hedef kullanıcı, temel özellikler, teknolojiler, veritabanı, özgün özellikler, yapay zeka kullanımı ve katkı beyanını içerir.",
    ))
