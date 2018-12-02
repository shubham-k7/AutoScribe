import glob
from fpdf import FPDF
pdf = FPDF()

imagelist=glob.glob("*.jpg")

for image in imagelist:
    pdf.add_page()
    pdf.image(image,w=190)
pdf.output("notes.pdf", "F")
