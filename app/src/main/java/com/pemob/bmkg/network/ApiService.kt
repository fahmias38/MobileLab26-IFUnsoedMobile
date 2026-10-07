package com.pemob.bmkg.network

import com.pemob.bmkg.model.GempaResponse
import retrofit2.http.GET

interface ApiService {
    @GET("DataMKG/TEWS/gempaterkini.json")
    suspend fun getGempa(): GempaResponse
}