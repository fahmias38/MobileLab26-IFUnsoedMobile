package com.pemob.bmkg.model

import com.google.gson.annotations.SerializedName

data class GempaResponse(
    @SerializedName("Infogempa")
    val infogempa: Infogempa
)

data class Infogempa(
    @SerializedName("gempa")
    val gempa: List<Gempa>
)