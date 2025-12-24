#!/bin/bash

ARCHIVO="index.html"

# Agregar función de carrusel antes del </script> final
LINEA_SCRIPT=$(grep -n "</script>" "$ARCHIVO" | tail -1 | cut -d: -f1)

sed -i "${LINEA_SCRIPT}i\\
// =============================================\\
// 🖼️ CARRUSEL DE IMÁGENES PARA PROPIEDADES\\
// =============================================\\
\\
function crearCarrusel(imagenes, idContenedor) {\\
    if (!imagenes || imagenes.length === 0) {\\
        return '<div style=\"padding: 40px; text-align: center; background: #f8f9fa; border-radius: 10px;\">\\
                  <i class=\"fas fa-image\" style=\"font-size: 48px; color: #ccc; margin-bottom: 15px;\"></i>\\
                  <p>No hay imágenes disponibles</p>\\
                </div>';\\
    }\\
    \\
    let html = \`<div id=\"\${idContenedor}\" class=\"carousel slide\" data-bs-ride=\"carousel\">\\
        <div class=\"carousel-indicators\">\`;\\
    \\
    // Indicadores\\
    imagenes.forEach((img, index) => {\\
        html += \`<button type=\"button\" data-bs-target=\"#\${idContenedor}\" data-bs-slide-to=\"\${index}\" \${index === 0 ? 'class=\"active\" aria-current=\"true\"' : ''} aria-label=\"Slide \${index + 1}\"></button>\`;\\
    });\\
    \\
    html += \`</div><div class=\"carousel-inner\" style=\"border-radius: 10px; overflow: hidden;\">\`;\\
    \\
    // Imágenes\\
    imagenes.forEach((img, index) => {\\
        html += \`<div class=\"carousel-item \${index === 0 ? 'active' : ''}\">\\
            <img src=\"\${img}\" class=\"d-block w-100\" style=\"height: 300px; object-fit: cover;\" alt=\"Imagen \${index + 1}\">\\
            <div class=\"carousel-caption d-none d-md-block\" style=\"background: rgba(0,0,0,0.5); padding: 10px; border-radius: 5px;\">\\
                <p>Imagen \${index + 1}</p>\\
            </div>\\
        </div>\`;\\
    });\\
    \\
    html += \`</div>\\
        <button class=\"carousel-control-prev\" type=\"button\" data-bs-target=\"#\${idContenedor}\" data-bs-slide=\"prev\">\\
            <span class=\"carousel-control-prev-icon\" aria-hidden=\"true\"></span>\\
            <span class=\"visually-hidden\">Anterior</span>\\
        </button>\\
        <button class=\"carousel-control-next\" type=\"button\" data-bs-target=\"#\${idContenedor}\" data-bs-slide=\"next\">\\
            <span class=\"carousel-control-next-icon\" aria-hidden=\"true\"></span>\\
            <span class=\"visually-hidden\">Siguiente</span>\\
        </button>\\
    </div>\`;\\
    \\
    return html;\\
}\\
\\
// Función para agregar imágenes a una propiedad\\
function agregarImagenesAPropiedad(idPropiedad) {\\
    const input = document.createElement('input');\\
    input.type = 'file';\\
    input.accept = 'image/*';\\
    input.multiple = true;\\
    input.onchange = function(e) {\\
        const files = e.target.files;\\
        const imagenes = [];\\
        \\
        // Convertir a URLs temporales\\
        Array.from(files).forEach(file => {\\
            const reader = new FileReader();\\
            reader.onload = function(e) {\\
                imagenes.push(e.target.result);\\
                \\
                // Guardar en localStorage\\
                const propiedad = JSON.parse(localStorage.getItem(idPropiedad));\\
                if (propiedad) {\\
                    propiedad.imagenes = imagenes;\\
                    localStorage.setItem(idPropiedad, JSON.stringify(propiedad));\\
                    alert(\`\${imagenes.length} imágenes agregadas\`);\\
                }\\
            };\\
            reader.readAsDataURL(file);\\
        });\\
    };\\
    input.click();\\
}" "$ARCHIVO"

echo "✅ Carrusel de imágenes agregado!"
