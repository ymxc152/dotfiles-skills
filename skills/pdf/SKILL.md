---
name: pdf
description: 当用户想对 PDF 文件做任何操作时使用。包括读取或提取文本/表格、合并多个 PDF、拆分 PDF、旋转页面、添加水印、创建新 PDF、填充 PDF 表单、加密/解密 PDF、提取图像，以及对扫描 PDF 进行 OCR 使其可搜索。如果用户提到 .pdf 文件或要求生成一个，使用本 skill。
license: Proprietary. LICENSE.txt has complete terms
---

# PDF Processing Guide（PDF 处理指南）

## Overview（概述）

本指南涵盖使用 Python 库和命令行工具的基本 PDF 处理操作。对于高级功能、JavaScript 库和详细示例，参见 REFERENCE.md。如果需要填写 PDF 表单，阅读 FORMS.md 并遵循其说明。

## Quick Start（快速开始）

```python
from pypdf import PdfReader, PdfWriter

# 读取 PDF
reader = PdfReader("document.pdf")
print(f"Pages: {len(reader.pages)}")

# 提取文本
text = ""
for page in reader.pages:
    text += page.extract_text()
```

## Python Libraries（Python 库）

### pypdf - 基本操作

#### 合并 PDFs
```python
from pypdf import PdfWriter, PdfReader

writer = PdfWriter()
for pdf_file in ["doc1.pdf", "doc2.pdf", "doc3.pdf"]:
    reader = PdfReader(pdf_file)
    for page in reader.pages:
        writer.add_page(page)

with open("merged.pdf", "wb") as output:
    writer.write(output)
```

#### 拆分 PDF
```python
reader = PdfReader("input.pdf")
for i, page in enumerate(reader.pages):
    writer = PdfWriter()
    writer.add_page(page)
    with open(f"page_{i+1}.pdf", "wb") as output:
        writer.write(output)
```

#### 提取元数据
```python
reader = PdfReader("document.pdf")
meta = reader.metadata
print(f"Title: {meta.title}")
print(f"Author: {meta.author}")
```

#### 旋转页面
```python
reader = PdfReader("input.pdf")
writer = PdfWriter()

page = reader.pages[0]
page.rotate(90)  # 顺时针旋转 90 度
writer.add_page(page)

with open("rotated.pdf", "wb") as output:
    writer.write(output)
```

### pdfplumber - 文本和表格提取

#### 提取带布局的文本
```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        print(text)
```

#### 提取表格
```python
with pdfplumber.open("document.pdf") as pdf:
    for i, page in enumerate(pdf.pages):
        tables = page.extract_tables()
        for j, table in enumerate(tables):
            print(f"Table {j+1} on page {i+1}:")
            for row in table:
                print(row)
```

#### 高级表格提取
```python
import pandas as pd

with pdfplumber.open("document.pdf") as pdf:
    all_tables = []
    for page in pdf.pages:
        tables = page.extract_tables()
        for table in tables:
            if table:
                df = pd.DataFrame(table[1:], columns=table[0])
                all_tables.append(df)

if all_tables:
    combined_df = pd.concat(all_tables, ignore_index=True)
    combined_df.to_excel("extracted_tables.xlsx", index=False)
```

### reportlab - 创建 PDF

#### 基本 PDF 创建
```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

c = canvas.Canvas("hello.pdf", pagesize=letter)
width, height = letter

c.drawString(100, height - 100, "Hello World!")
c.line(100, height - 140, 400, height - 140)
c.save()
```

#### 创建多页 PDF
```python
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet

doc = SimpleDocTemplate("report.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = []

story.append(Paragraph("Report Title", styles['Title']))
story.append(Spacer(1, 12))
story.append(Paragraph("Content...", styles['Normal']))
story.append(PageBreak())
story.append(Paragraph("Page 2", styles['Heading1']))

doc.build(story)
```

**重要**：永远不要在 ReportLab PDF 中使用 Unicode 下标/上标字符。使用 XML markup tags：
```python
# 下标：使用 <sub> 标签
chemical = Paragraph("H<sub>2</sub>O", styles['Normal'])
# 上标：使用 <super> 标签
squared = Paragraph("x<super>2</super> + y<super>2</super>", styles['Normal'])
```

## Command-Line Tools（命令行工具）

### pdftotext (poppler-utils)
```bash
# 提取文本
pdftotext input.pdf output.txt
# 保留布局提取
pdftotext -layout input.pdf output.txt
# 提取特定页面
pdftotext -f 1 -l 5 input.pdf output.txt  # 第 1-5 页
```

### qpdf
```bash
# 合并 PDFs
qpdf --empty --pages file1.pdf file2.pdf -- merged.pdf
# 拆分页面
qpdf input.pdf --pages . 1-5 -- pages1-5.pdf
# 旋转页面
qpdf input.pdf output.pdf --rotate=+90:1
# 移除密码
qpdf --password=mypassword --decrypt encrypted.pdf decrypted.pdf
```

## Common Tasks（常见任务）

### 从扫描 PDF 提取文本（OCR）
```python
import pytesseract
from pdf2image import convert_from_path

images = convert_from_path('scanned.pdf')
text = ""
for i, image in enumerate(images):
    text += f"Page {i+1}:\n"
    text += pytesseract.image_to_string(image)
```

### 添加水印
```python
from pypdf import PdfReader, PdfWriter

watermark = PdfReader("watermark.pdf").pages[0]
reader = PdfReader("document.pdf")
writer = PdfWriter()

for page in reader.pages:
    page.merge_page(watermark)
    writer.add_page(page)

with open("watermarked.pdf", "wb") as output:
    writer.write(output)
```

### 提取图像
```bash
pdfimages -j input.pdf output_prefix
```

### 密码保护
```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader("input.pdf")
writer = PdfWriter()
for page in reader.pages:
    writer.add_page(page)

writer.encrypt("userpassword", "ownerpassword")
with open("encrypted.pdf", "wb") as output:
    writer.write(output)
```

## Quick Reference（快速参考）

| 任务 | 最佳工具 | 命令/代码 |
|------|---------|----------|
| 合并 PDFs | pypdf | `writer.add_page(page)` |
| 拆分 PDFs | pypdf | 每页一个文件 |
| 提取文本 | pdfplumber | `page.extract_text()` |
| 提取表格 | pdfplumber | `page.extract_tables()` |
| 创建 PDFs | reportlab | Canvas 或 Platypus |
| 命令行合并 | qpdf | `qpdf --empty --pages ...` |
| OCR 扫描 PDF | pytesseract | 先转换为图像 |
| 填充 PDF 表单 | pdf-lib 或 pypdf | 参见 FORMS.md |

## Next Steps（下一步）

- 高级 pypdfium2 用法，参见 REFERENCE.md
- JavaScript 库（pdf-lib），参见 REFERENCE.md
- 如需填写 PDF 表单，遵循 FORMS.md 中的说明
- 故障排除指南，参见 REFERENCE.md
