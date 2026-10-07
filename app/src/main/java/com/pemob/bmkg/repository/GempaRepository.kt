package com.pemob.bmkg.repository

import com.pemob.bmkg.model.Gempa
import com.pemob.bmkg.network.ApiService

class GempaRepository (
    private val apiService: ApiService
) {
    suspend fun getGempa(): List<Gempa> {
        return apiService.getGempa().infogempa.gempa
    }
}