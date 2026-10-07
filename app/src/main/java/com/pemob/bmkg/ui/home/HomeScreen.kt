package com.pemob.bmkg.ui.home

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import com.pemob.bmkg.viewmodel.GempaViewModel
import androidx.compose.runtime.getValue
import androidx.lifecycle.viewmodel.compose.viewModel
import com.pemob.bmkg.uiState.UiState
import com.pemob.bmkg.viewmodel.GempaViewModelFactory
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.runtime.setValue
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.pemob.bmkg.model.Gempa

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    onGempaClick: (Gempa) -> Unit,
    viewModel: GempaViewModel = viewModel(
        factory = GempaViewModelFactory()
    )
) {
    val uiState by viewModel.uiState.collectAsState()

    var searchQuery by rememberSaveable {
        mutableStateOf("")
    }

    LaunchedEffect(Unit) {
        viewModel.getGempa()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("Gempa Terkini")
                }
            )
        }
    ) { innerPadding ->

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {

            OutlinedTextField(
                value = searchQuery,
                onValueChange = {
                    searchQuery = it
                },
                label = {
                    Text("Cari wilayah")
                },
                placeholder = {
                    Text("Contoh: TARAKAN")
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(
                        horizontal = 16.dp,
                        vertical = 8.dp
                    ),
                singleLine = true
            )

            when (uiState) {

                is UiState.Loading -> {
                    Text(
                        text = "Loading...",
                        modifier = Modifier.padding(16.dp)
                    )
                }

                is UiState.Success -> {

                    val gempaList =
                        (uiState as UiState.Success).data

                    val filteredGempa =
                        gempaList.filter {
                            it.wilayah.contains(
                                searchQuery,
                                ignoreCase = true
                            )
                        }

                    Text(
                        text = "${filteredGempa.size} gempa ditemukan",
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.SemiBold,
                        color = MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier.padding(
                            horizontal = 16.dp,
                            vertical = 4.dp
                        )
                    )

                    LazyColumn(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        contentPadding = PaddingValues(
                            bottom = 16.dp
                        )
                    ) {
                        items(
                            items = filteredGempa,
                            key = {
                                it.tanggal + it.jam
                            }
                        ) { gempa ->

                            GempaItem(
                                gempa = gempa,
                                onClick = {
                                    onGempaClick(gempa)
                                }
                            )
                        }
                    }
                }

                is UiState.Error -> {
                    Text(
                        text = "Error: ${
                            (uiState as UiState.Error).message
                        }",
                        modifier = Modifier.padding(16.dp)
                    )
                }
            }
        }
    }
}