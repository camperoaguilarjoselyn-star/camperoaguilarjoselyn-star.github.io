#!/bin/bash

ARCHIVO="index.html"

# Buscar la línea donde cierra </head>
LINEA_HEAD=$(grep -n "</head>" "$ARCHIVO" | tail -1 | cut -d: -f1)

if [ -z "$LINEA_HEAD" ]; then
    echo "❌ No encontré </head> en el archivo"
    exit 1
fi

echo "📌 Insertando animaciones antes de línea: $LINEA_HEAD"

# Insertar los estilos animados
sed -i "${LINEA_HEAD}i\\
<style>\\
/* =========================================== */\\
/* 🎨 ANIMACIONES PARA INMOBILIARIA CAMPERO   */\\
/* =========================================== */\\
\\
/* Animación de entrada para propiedades */\\
@keyframes fadeInUp {\\
    from {\\
        opacity: 0;\\
        transform: translateY(30px);\\
    }\\
    to {\\
        opacity: 1;\\
        transform: translateY(0);\\
    }\\
}\\
\\
/* Animación para cards de propiedades */\\
.propiedad-card, .card, .property-card {\\
    animation: fadeInUp 0.6s ease-out;\\
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);\\
}\\
\\
.propiedad-card:hover, .card:hover, .property-card:hover {\\
    transform: translateY(-10px) scale(1.02);\\
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);\\
    z-index: 10;\\
}\\
\\
/* Animación para botones */\\
@keyframes pulse {\\
    0% { transform: scale(1); }\\
    50% { transform: scale(1.05); }\\
    100% { transform: scale(1); }\\
}\\
\\
.btn-primary, button[type='submit'], .btn-success {\\
    transition: all 0.3s ease;\\
    position: relative;\\
    overflow: hidden;\\
}\\
\\
.btn-primary:hover, button[type='submit']:hover, .btn-success:hover {\\
    animation: pulse 0.5s ease;\\
    transform: translateY(-3px);\\
    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);\\
}\\
\\
/* Animación para imágenes */\\
.property-image {\\
    transition: transform 0.5s ease;\\
}\\
\\
.property-image:hover {\\
    transform: scale(1.1);\\
}\\
\\
/* Animación para precios */\\
.precio-propiedad {\\
    animation: bounceIn 1s ease;\\
    display: inline-block;\\
}\\
\\
@keyframes bounceIn {\\
    0% {\\
        transform: scale(0.3);\\
        opacity: 0;\\
    }\\
    50% {\\
        transform: scale(1.05);\\
    }\\
    70% {\\
        transform: scale(0.9);\\
    }\\
    100% {\\
        transform: scale(1);\\
        opacity: 1;\\
    }\\
}\\
\\
/* Animación de carga */\\
.spinner {\\
    border: 4px solid #f3f3f3;\\
    border-top: 4px solid #667eea;\\
    border-radius: 50%;\\
    width: 40px;\\
    height: 40px;\\
    animation: spin 1s linear infinite;\\
}\\
\\
@keyframes spin {\\
    0% { transform: rotate(0deg); }\\
    100% { transform: rotate(360deg); }\\
}\\
</style>" "$ARCHIVO"

echo "✅ Animaciones CSS agregadas exitosamente!"
echo "🎨 Tu página ahora tendrá efectos visuales profesionales"
