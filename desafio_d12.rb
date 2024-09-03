require 'net/http'
require 'json'

# Método para realizar la solicitud a la API y retornar un hash con los resultados
def request(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response) # Convertir la respuesta JSON a un hash de Ruby
end

# Método para construir la página web con las imágenes obtenidas de la API
def build_web_page(data)
  # Inicio del HTML con integración de Bootstrap
  html = <<-HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dog Image Carousel</title>
    <!-- Enlace al CSS de Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
      .carousel-item img {
        width: 100%;
        height: auto;
        max-height: 500px; /* Limitar la altura máxima para pantallas grandes */
        object-fit: cover; /* Mantener la proporción de la imagen */
      }
      @media (max-width: 768px) { /* Ajustes para pantallas pequeñas */
        .carousel-item img {
          max-height: 300px; /* Reducir la altura máxima en pantallas más pequeñas */
        }
      }
    </style>
  </head>
  <body>
    <div class="container mt-5">
      <div id="dogCarousel" class="carousel slide" data-ride="carousel">
        <div class="carousel-inner">
  HTML

  # Generar los elementos del carrusel con las imágenes obtenidas
  data.each_with_index do |image, index|
    html += <<-HTML
          <div class="carousel-item #{'active' if index == 0}">
            <img src="#{image['message']}" alt="Dog Image" class="d-block w-100">
          </div>
    HTML
  end

  # Continuación del HTML con controles del carrusel
  html += <<-HTML
        </div>
        <!-- Controles del carrusel -->
        <a class="carousel-control-prev" href="#dogCarousel" role="button" data-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#dogCarousel" role="button" data-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="sr-only">Next</span>
        </a>
      </div>
    </div>
    
    <!-- Enlaces a los scripts de Bootstrap -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  </body>
  </html>
  HTML

  # Escribir el contenido en un archivo HTML
  File.open('index.html', 'w') do |file|
    file.write(html)
  end
end

# Método para contar el número de imágenes obtenidas
def photos_count(data)
  { 'images_count' => data.size }
end

# URL de la API de imágenes de perros
url = 'https://dog.ceo/api/breeds/image/random'

# Hacer múltiples solicitudes a la API para obtener varias imágenes
images = []
10.times do
  images << request(url)
end

# Construir la página web con las imágenes obtenidas
build_web_page(images)

# Mostrar el conteo de imágenes en la consola
puts photos_count(images)


