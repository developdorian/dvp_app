# Prueba técnica Double V Partners 

Aplicación Flutter que permite gestionar perfiles de usuarios con información personal y de dirección. 

## 📋 Funcionalidades

- **Onboarding**: Pantalla de bienvenida inicial con splash screen
- **Formulario de Usuario**: Captura de datos personales (nombre, apellido, fecha de nacimiento) y dirección (país, departamento, ciudad, dirección).
- **Gestión de Perfiles**: Visualización de usuarios guardados con opción de actualizar y eliminar
- **Integración con API**: Búsqueda de ciudades mediante GeoDB Cities API
- **Persistencia Local**: Almacenamiento de datos con Hive
- **Testing**: Pruebas unitarias

## 🚀 Cómo Clonar y Ejecutar

### Prerrequisitos
- Flutter SDK 3.35.3

### Pasos de Instalación

1. **Clonar el repositorio**
2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar código necesario**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación**

## 🔑 API Key Incluida

Para facilitar la evaluación, en este proyecto incluí una API Key de RapidAPI ya configurada, con esto funcionará correctamente al clonar el repositorio. Esta key tiene límites del plan gratuito de GeoDB Cities API. En un ambiente productivo utilizaría el archivo .env para almacenar la API Key.

## 🛠️ Tecnologías Utilizadas

- **Flutter & Dart**: Framework principal
- **Riverpod**: Gestión de estado
- **GoRouter**: Navegación
- **Hive**: Base de datos local
- **Dio**: Cliente HTTP
- **Freezed**: Generación de modelos inmutables
- **Dartz**: Programación funcional (Either para manejo de errores)

