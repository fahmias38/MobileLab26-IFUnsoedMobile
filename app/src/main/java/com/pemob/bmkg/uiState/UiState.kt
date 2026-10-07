package com.pemob.bmkg.uiState

import com.pemob.bmkg.model.Gempa

sealed class UiState {
    object Loading : UiState()

    data class Success(
        val data: List<Gempa>
    ) : UiState()

    data class Error(
        val message: String
    ) : UiState()
}