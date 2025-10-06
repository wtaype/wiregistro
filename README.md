# 💰 WiRegistro - App de Registro de Gastos

Aplicación móvil Flutter para registrar y gestionar gastos personales con Firebase.

## 🚀 Características

- ✅ Registro de gastos con categorías
- ✅ Visualización en tiempo real con Firebase Firestore
- ✅ Cálculo automático de totales
- ✅ Interfaz intuitiva con Material Design 3
- ✅ Soporte para múltiples categorías (Comida, Transporte, etc.)

## 📱 Tecnologías

- Flutter 3.9+
- Firebase (Firestore, Auth)
- Google Fonts
- Material Design 3

## 🔧 Configuración

### 1. Clonar el repositorio

```bash
git clone [tu-repo-url]
cd wiregistro
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

**IMPORTANTE:** Necesitas configurar tu propio proyecto de Firebase.

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto
3. Ejecuta:

```bash
flutterfire configure
```

4. Esto generará automáticamente:
   - `firebase_options.dart`
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)

### 4. Ejecutar la app

```bash
flutter run
```

## 📂 Estructura del proyecto

```
lib/
├── main.dart                      # Punto de entrada
├── firebase_options.dart          # Configuración Firebase (NO incluido)
├── modelos/
│   └── gasto.dart                # Modelo de datos
├── servicios/
│   └── fb_servicio.dart          # Servicio Firestore
├── pantallas/
│   ├── inicio_pantalla.dart      # Pantalla principal
│   └── agregar_gasto_pantalla.dart
└── widgets/
    └── tarjeta_gasto.dart        # Widget de tarjeta
```

## 🔒 Seguridad

Los siguientes archivos están en `.gitignore` por seguridad:
- `firebase_options.dart`
- `google-services.json`
- `GoogleService-Info.plist`

**Cada desarrollador debe configurar su propio proyecto Firebase.**

## 👨‍💻 Autor

Desarrollado con ❤️ por @wilder_taype 

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la Licencia MIT.