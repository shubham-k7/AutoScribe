import glob
from fpdf import FPDF
pdf = FPDF()

imagelist=glob.glob("Output_en2/*.jpg")
imagelist.sort()
print(imagelist)
for image in imagelist:
    pdf.add_page()
    pdf.image(image,w=150)
pdf.output("notes_edge_enhance.pdf", "F")
