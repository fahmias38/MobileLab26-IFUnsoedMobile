package com.pemob.bmkg

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.compose.rememberNavController
import com.pemob.bmkg.ui.home.HomeScreen
import com.pemob.bmkg.ui.theme.BMKGTheme
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.pemob.bmkg.ui.detail.DetailScreen
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import com.pemob.bmkg.model.Gempa

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            BMKGTheme {
                val navController = rememberNavController()
                var selectedGempa by remember {
                    mutableStateOf<Gempa?>(null)
                }

                NavHost(
                    navController = navController,
                    startDestination = "home"
                ) {
                    composable ("home") {
                        HomeScreen(
                            onGempaClick = { gempa ->
                                selectedGempa = gempa
                                navController.navigate("detail")
                            }
                        )
                    }

                    composable ("detail") {
                        selectedGempa?.let { gempa ->
                            DetailScreen(
                                gempa = gempa,
                                onBack = {
                                    navController.popBackStack()
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    BMKGTheme {
        Greeting("Android")
    }
}