package com.pemob.bmkg.model

import com.google.gson.annotations.SerializedName

data class Gempa(
    @SerializedName("Tanggal")
    val tanggal: String,

    @SerializedName("Jam")
    val jam: String,

    @SerializedName("Coordinates")
    val coordinates: String,

    @SerializedName("Magnitude")
    val magnitude: String,

    @SerializedName("Kedalaman")
    val kedalaman: String,

    @SerializedName("Wilayah")
    val wilayah: String,

    @SerializedName("Potensi")
    val potensi: String
)

