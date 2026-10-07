package com.pemob.bmkg.ui.detail

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.pemob.bmkg.model.Gempa
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DetailScreen(
    gempa: Gempa,
    onBack: () -> Unit
) {

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("Detail Gempa")
                },
                navigationIcon = {
                    IconButton(
                        onClick = onBack
                    ) {
                        Text(
                            text = "←",
                            style = MaterialTheme.typography.headlineSmall
                        )
                    }
                }
            )
        }
    ) { innerPadding ->

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp)
        ) {

            DetailRow(
                label = "Tanggal",
                value = gempa.tanggal
            )

            DetailRow(
                label = "Jam",
                value = gempa.jam
            )

            DetailRow(
                label = "Coordinates",
                value = gempa.coordinates
            )

            DetailRow(
                label = "Magnitudo",
                value = gempa.magnitude
            )

            DetailRow(
                label = "Kedalaman",
                value = gempa.kedalaman
            )

            DetailRow(
                label = "Wilayah",
                value = gempa.wilayah
            )

            DetailRow(
                label = "Potensi",
                value = gempa.potensi
            )
        }
    }
}

@Composable
fun DetailRow(
    label: String,
    value: String
) {
    Column(
        modifier = Modifier.padding(vertical = 8.dp)
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.primary
        )

        Text(
            text = value,
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurface
        )
    }
}