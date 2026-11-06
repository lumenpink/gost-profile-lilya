#!/usr/bin/env python3
"""
Gera o banner de compartilhamento Open Graph / Twitter Card (1200x630 pixels)
para o perfil GOST Lilya com Safe Zone 4:3 no miolo centralizado (blindado contra
recortes do WhatsApp e redes móveis), tipografia nítida e estética transfeminista hacker.
"""

import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_og_image(output_path="site/assets/og_preview.png"):
    width, height = 1200, 630

    # 1. Base com fundo profundo Dark Mode
    base = Image.new("RGBA", (width, height), (13, 17, 23, 255))
    draw = ImageDraw.Draw(base)

    # Grade cibernética sutil
    grid_spacing = 32
    grid_color = (30, 41, 59, 90)
    for x in range(0, width, grid_spacing):
        draw.line([(x, 0), (x, height)], fill=grid_color, width=1)
    for y in range(0, height, grid_spacing):
        draw.line([(0, y), (width, y)], fill=grid_color, width=1)

    # 2. Luz difusa central (Glows magenta transfeminista #ff79c6 e ciano #58a6ff)
    glow_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)
    glow_draw.ellipse([340, 70, 860, 510], fill=(255, 121, 198, 45))
    glow_draw.ellipse([270, 110, 930, 540], fill=(88, 166, 255, 30))
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(80))
    base = Image.alpha_composite(base, glow_layer)

    # 3. Fontes
    font_bold_candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    ]
    font_reg_candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    ]

    font_bold_path = next((f for f in font_bold_candidates if os.path.exists(f)), None)
    font_reg_path = next((f for f in font_reg_candidates if os.path.exists(f)), None)

    f_badge = ImageFont.truetype(font_bold_path, 16) if font_bold_path else ImageFont.load_default()
    f_brand = ImageFont.truetype(font_bold_path, 72) if font_bold_path else ImageFont.load_default()
    f_title1 = ImageFont.truetype(font_bold_path, 34) if font_bold_path else ImageFont.load_default()
    f_title2 = ImageFont.truetype(font_bold_path, 25) if font_bold_path else ImageFont.load_default()
    f_url = ImageFont.truetype(font_bold_path, 22) if font_bold_path else ImageFont.load_default()
    f_author = ImageFont.truetype(font_reg_path, 19) if font_reg_path else ImageFont.load_default()

    tdraw = ImageDraw.Draw(base)

    # 4. Badge superior centralizado (<= 35 chars)
    b_text = " GOST // PERFIL LUMEN // EXTENDS KOLLONTAI "
    b_box = tdraw.textbbox((0, 0), b_text, font=f_badge)
    bw = b_box[2] - b_box[0]
    bx = (width - bw) // 2
    by = 54
    tdraw.rectangle([bx - 14, by - 6, bx + bw + 14, by + 26], fill=(22, 27, 34, 230), outline=(255, 121, 198, 220), width=1)
    tdraw.text((bx, by), b_text, font=f_badge, fill=(255, 121, 198, 255))

    # 5. Título Principal da Marca / Perfil
    brand_text = "gost-profile-lumen"
    br_box = tdraw.textbbox((0, 0), brand_text, font=f_brand)
    brand_w = br_box[2] - br_box[0]
    brand_x = (width - brand_w) // 2
    brand_y = 125
    tdraw.text((brand_x, brand_y), brand_text, font=f_brand, fill=(255, 255, 255, 255))

    # Linha de destaque sob a marca
    accent_line_w = 420
    accent_line_x = (width - accent_line_w) // 2
    accent_line_y = brand_y + 88
    tdraw.line([(accent_line_x, accent_line_y), (accent_line_x + accent_line_w, accent_line_y)], fill=(255, 121, 198, 220), width=3)

    # 6. Títulos de alto impacto no Miolo Central (Safe Zone 4:3: 720-840px útil)
    t1_text = "Perfil de Implementação Lilya"
    t1_box = tdraw.textbbox((0, 0), t1_text, font=f_title1)
    t1_x = (width - (t1_box[2] - t1_box[0])) // 2
    t1_y = 265
    tdraw.text((t1_x, t1_y), t1_text, font=f_title1, fill=(240, 246, 252, 250))

    t2_text = "Norma GOST 2.0.0 • Estilo • Rodapé • Dark Mode • KokoroSim OG"
    t2_box = tdraw.textbbox((0, 0), t2_text, font=f_title2)
    t2_x = (width - (t2_box[2] - t2_box[0])) // 2
    t2_y = 330
    tdraw.text((t2_x, t2_y), t2_text, font=f_title2, fill=(88, 166, 255, 250))

    sub_extra = "Afirmação transfeminista, autonomia digital e rigor técnico"
    se_box = tdraw.textbbox((0, 0), sub_extra, font=f_author)
    se_x = (width - (se_box[2] - se_box[0])) // 2
    se_y = 380
    tdraw.text((se_x, se_y), sub_extra, font=f_author, fill=(139, 148, 158, 240))

    # 7. Rodapé no miolo (largura de 760px, bottom padding de 85px)
    foot_y = height - 85
    f_bar_w = 760
    f_bar_x = (width - f_bar_w) // 2
    tdraw.line([(f_bar_x, foot_y - 18), (f_bar_x + f_bar_w, foot_y - 18)], fill=(48, 54, 61, 200), width=1)

    # Ponto neon de status
    tdraw.ellipse([f_bar_x, foot_y + 4, f_bar_x + 14, foot_y + 18], fill=(255, 121, 198, 255))
    tdraw.text((f_bar_x + 24, foot_y), "lilya.2lp.in", font=f_url, fill=(88, 166, 255, 255))

    auth_text = "Lumen Pink // Brasil // CC-BY-SA-4.0"
    abox = tdraw.textbbox((0, 0), auth_text, font=f_author)
    tdraw.text((f_bar_x + f_bar_w - (abox[2] - abox[0]), foot_y + 2), auth_text, font=f_author, fill=(139, 148, 158, 230))

    # Borda decorativa superior e inferior
    tdraw.line([(0, 0), (width, 0)], fill=(255, 121, 198, 255), width=3)
    tdraw.line([(0, height - 1), (width, height - 1)], fill=(88, 166, 255, 200), width=2)

    # 8. Salvar imagem otimizada em PNG
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    base = base.convert("RGB")
    base.save(output_path, format="PNG", optimize=True)
    file_size_kb = os.path.getsize(output_path) / 1024
    print(f"✅ Banner OG Lilya centrado com Safe Zone 4:3 gerado: {output_path} ({width}x{height}, {file_size_kb:.1f} KB)")

if __name__ == "__main__":
    create_og_image()
