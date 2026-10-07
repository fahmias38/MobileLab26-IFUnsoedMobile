package com.pemob.bmkg.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.pemob.bmkg.network.RetrofitInstance
import com.pemob.bmkg.repository.GempaRepository

class GempaViewModelFactory : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(GempaViewModel::class.java)) {
            val repository = GempaRepository(
                RetrofitInstance.api
            )

            @Suppress("UNCHECKED_CAST")
            return GempaViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}