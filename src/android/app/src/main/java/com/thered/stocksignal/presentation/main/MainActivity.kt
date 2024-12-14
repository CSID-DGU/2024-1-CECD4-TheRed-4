package com.thered.stocksignal.presentation.main

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.widget.FrameLayout
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.thered.stocksignal.presentation.alarm.AlarmActivity
import com.thered.stocksignal.presentation.home.HomeFragment
import com.thered.stocksignal.presentation.mypage.MypageFragment
import com.thered.stocksignal.presentation.search.SearchFragment
import com.thered.stocksignal.R
//import com.thered.stocksignal.data.repositories.StockListRepository
import com.thered.stocksignal.domain.usecases.StockListUseCase
import com.thered.stocksignal.presentation.chatbot.PracticeActivity


class MainActivity : AppCompatActivity() {
    private val toolbar: Toolbar by lazy { findViewById(R.id.toolbar)}
    private val main_container: FrameLayout by lazy { findViewById(R.id.main_container) }
    private  val navigation: BottomNavigationView by lazy { findViewById(R.id.bottom_navigation_view) }

    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)

        supportFragmentManager.beginTransaction().add(main_container.id, HomeFragment()).commit()
        navigation.menu.findItem(R.id.fragment_home).setChecked(true)

        navigation.run {
            setOnItemSelectedListener { item ->
                when (item.itemId) {
                    R.id.fragment_search -> changeFragment(SearchFragment())
                    R.id.fragment_home -> changeFragment(HomeFragment())
                    R.id.fragment_mypage -> changeFragment(MypageFragment())
                }
                true
            }
        }
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun changeFragment(fragment: Fragment)
    {
        supportFragmentManager.beginTransaction()
            .replace(main_container.id, fragment)
            .commit()
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu_app_bar, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_bar_chatbot -> {
                val intent = Intent(this, PracticeActivity::class.java)
                startActivity(intent)
                true
            }
            R.id.action_bar_alarm -> {
                val intent = Intent(this, AlarmActivity::class.java)
                startActivity(intent)
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}