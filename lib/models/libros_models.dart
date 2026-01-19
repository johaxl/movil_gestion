class LibrosModels {
  int? id;
  String titulo;
  String isbn;
  int anioPublicacion;
  int idAutor;
  String editorial;

  LibrosModels({
    this.id,
    required this.titulo,
    required this.isbn,
    required this.anioPublicacion,
    required this.idAutor,
    required this.editorial,
  });

  factory LibrosModels.fromMap(Map<String, dynamic> data) {
    return LibrosModels(
      id: data['id'],
      titulo: data['titulo'],
      isbn: data['isbn'],
      anioPublicacion: data['anio_publicacion'],
      idAutor: data['id_autor'],
      editorial: data['editorial'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'isbn': isbn,
      'anio_publicacion': anioPublicacion,
      'id_autor': idAutor,
      'editorial': editorial,
    };
  }
}
