package com.pemob.bmkg.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pemob.bmkg.repository.GempaRepository
import com.pemob.bmkg.uiState.UiState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class GempaViewModel(
    private val repository: GempaRepository
) : ViewModel() {
    private val _uiState = MutableStateFlow<UiState>(UiState.Loading)

    val uiState: StateFlow<UiState> = _uiState

    fun getGempa() {
        viewModelScope.launch {
            _uiState.value = UiState.Loading

            try {
                val data =  repository.getGempa()
                _uiState.value = UiState.Success(data)
            } catch (e: Exception) {
                _uiState.value = UiState.Error(
                    e.message ?: "Terjadi kesalahan"
                )
            }
        }
    }
}