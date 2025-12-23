#!/bin/bash

ARCHIVO="index.html"

# Buscar la línea donde cierra </head>
LINEA_HEAD=$(grep -n "</head>" "$ARCHIVO" | tail -1 | cut -d: -f1)

if [ -z "$LINEA_HEAD" ]; then
    echo "❌ No encontré </head> en el archivo"
    exit 1
fi

echo "📌 Agregando responsividad móvil en línea: $LINEA_HEAD"

# Insertar meta viewport y estilos responsivos
sed -i "${LINEA_HEAD}i\\
<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>\\
<style>\\
/* =========================================== */\\
/* 📱 DISEÑO RESPONSIVO PARA MÓVILES          */\\
/* =========================================== */\\
\\
@media (max-width: 768px) {\\
    /* Ajustes generales */\\
    body {\\
        font-size: 14px;\\
        padding: 10px;\\
    }\\
    \\
    /* Ajustar títulos */\\
    h1 { font-size: 24px !important; }\\
    h2 { font-size: 20px !important; }\\
    h3 { font-size: 18px !important; }\\
    \\
    /* Ajustar grid de propiedades */\\
    .row {\\
        margin-left: -8px !important;\\
        margin-right: -8px !important;\\
    }\\
    \\
    .col-md-4, .col-lg-3 {\\
        padding-left: 8px !important;\\
        padding-right: 8px !important;\\
        width: 100% !important;\\
        margin-bottom: 15px;\\
    }\\
    \\
    /* Ajustar cards */\\
    .card {\\
        margin-bottom: 15px;\\
        width: 100% !important;\\
    }\\
    \\
    /* Ajustar formularios */\\
    .form-control, select, input, textarea {\\
        font-size: 16px; /* Evita zoom en iOS */\\
        padding: 12px;\\
        margin-bottom: 10px;\\
    }\\
    \\
    /* Ajustar botones */\\
    .btn {\\
        padding: 12px 20px;\\
        font-size: 16px;\\
        width: 100%;\\
        margin-bottom: 10px;\\
    }\\
    \\
    /* Panel de administración móvil */\\
    #panelAdmin {\\
        width: 95% !important;\\
        right: 2.5% !important;\\
        max-height: 90vh;\\
        overflow-y: auto;\\
    }\\
    \\
    /* Sección de sincronización */\\
    #seccion-sincronizacion {\\
        padding: 15px !important;\\
        margin: 10px !important;\\
    }\\
    \\
    #seccion-sincronizacion .btn {\\
        margin-bottom: 10px;\\
    }\\
    \\
    /* Ajustar modales */\\
    .modal-dialog {\\
        margin: 10px;\\
        width: auto;\\
    }\\
    \\
    /* Ajustar navbar */\\
    .navbar-nav {\\
        flex-direction: column;\\
    }\\
    \\
    .nav-item {\\
        margin-bottom: 5px;\\
    }\\
    \\
    /* Ajustar filtros */\\
    .filtros-container {\\
        flex-direction: column;\\
    }\\
    \\
    .filtro-item {\\
        width: 100%;\\
        margin-bottom: 10px;\\
    }\\
    \\
    /* Ajustar imágenes */\\
    .property-image {\\
        height: 200px !important;\\
        object-fit: cover;\\
    }\\
    \\
    /* Ajustar tablas */\\
    table {\\
        font-size: 12px;\\
    }\\
    \\
    /* Ocultar elementos no esenciales en móvil */\\
    .d-none-mobile {\\
        display: none !important;\\
    }\\
    \\
    /* Mostrar elementos específicos para móvil */\\
    .d-mobile-only {\\
        display: block !important;\\
    }\\
}\\
\\
/* Para tablets */\\
@media (min-width: 769px) and (max-width: 1024px) {\\
    .col-md-4 {\\
        width: 50% !important;\\
    }\\
    \\
    .modal-dialog {\\
        max-width: 90%;\\
    }\\
}\\
\\
/* Mejoras de usabilidad táctil */\\
@media (hover: none) and (pointer: coarse) {\\
    .btn {\\
        min-height: 44px; /* Tamaño mínimo para dedos */\\
    }\\
    \\
    input, select, textarea {\\
        min-height: 44px;\\
    }\\
    \\
    /* Aumentar área de toque */\\
    .nav-link, .dropdown-item {\\
        padding: 12px 20px;\\
    }\\
}\\
</style>" "$ARCHIVO"

echo "✅ Diseño responsivo agregado exitosamente!"
echo "📱 Tu página ahora se verá perfecta en celulares y tablets"
