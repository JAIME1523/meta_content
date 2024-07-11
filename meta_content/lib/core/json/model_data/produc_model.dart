import 'dart:convert';

class ProductModel {
    int id;
    String name;
    String status;
    String species;
    String image;
    String precie;

    ProductModel({
        required this.id,
        required this.name,
        required this.status,
        required this.species,
        required this.image,
        required this.precie,
    });

    ProductModel copyWith({
        int? id,
        String? name,
        String? status,
        String? species,
        String? image,
        String? precie,
    }) => 
        ProductModel(
            id: id ?? this.id,
            name: name ?? this.name,
            status: status ?? this.status,
            species: species ?? this.species,
            image: image ?? this.image,
            precie: precie ?? this.precie,
        );

    factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        species: json["species"],
        image: json["image"],
        precie: json["precie"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "species": species,
        "image": image,
        "precie": precie,
    };
}
