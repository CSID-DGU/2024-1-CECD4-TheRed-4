package com.thered.stocksignal.presentation.newScenario

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.FrameLayout
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.thered.stocksignal.presentation.newScenario.buy.BuyRateFragment
import com.thered.stocksignal.presentation.newScenario.buy.BuyTargetFragment
import com.thered.stocksignal.presentation.newScenario.buy.BuyTradingFragment
import com.thered.stocksignal.presentation.newScenario.sell.SellRateFragment
import com.thered.stocksignal.presentation.newScenario.sell.SellTargetFragment
import com.thered.stocksignal.presentation.newScenario.sell.SellTradingFragment
import com.thered.stocksignal.R

class NewScenarioConditionActivity : AppCompatActivity() {

    private var buySellIndex: Int = 0
    private var standardIndex: Int = 0
    private var tradeStandardIndex: Int = 0
    private var optionIndex: Int = 0
    private var amountIndex: Int = 0

    private val container: FrameLayout by lazy { findViewById(R.id.new_scenario_container) }

    private val buyButton: Button by lazy { findViewById(R.id.new_scenario_buy_button) }
    private val sellButton: Button by lazy { findViewById(R.id.new_scenario_sell_button) }
    private val rateButton: Button by lazy { findViewById(R.id.new_scenario_rate_button) }
    private val targetButton: Button by lazy { findViewById(R.id.new_scenario_target_button) }
    private val tradingButton: Button by lazy { findViewById(R.id.new_scenario_trading_button) }

    private val standard1Button: Button by lazy { findViewById(R.id.new_scenario_standard1_button) }
    private val standard2Button: Button by lazy { findViewById(R.id.new_scenario_standard2_button) }

    private val setAmountButton: Button by lazy { findViewById(R.id.set_amount_button)}
    private val setRateButton: Button by lazy { findViewById(R.id.set_rate_button)}

    private val addButton: Button by lazy { findViewById(R.id.new_scenario_add_button)}

    private var textcolor = arrayOf(R.color.white, R.color.light_gray)
    private var backgroundColor = arrayOf(R.drawable.gray_border_box, R.drawable.radius_border_blue_box, R.drawable.radius_border_red_box)
    private var checkBoxColor = arrayOf(R.drawable.baseline_check_box_gray, R.drawable.baseline_check_box_blue, R.drawable.baseline_check_box_red)

    @SuppressLint("ResourceAsColor")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_new_scenario_condition)

        buyButton.setOnClickListener {
            buySellIndex = 0
            setButtonColor()
            setFragment()
        }

        sellButton.setOnClickListener {
            buySellIndex = 1
            setButtonColor()
            setFragment()
        }

        rateButton.setOnClickListener {
            standardIndex = 0
            setButtonColor()
            setFragment()
        }

        targetButton.setOnClickListener {
            standardIndex = 1
            setButtonColor()
            setFragment()
        }

        tradingButton.setOnClickListener {
            standardIndex = 2
            setButtonColor()
            setFragment()
        }

        standard1Button.setOnClickListener {
            tradeStandardIndex = 1
            setButton(standard1Button, 0, buySellIndex + 1)
            setButton(standard2Button, 1, 0)
        }

        standard2Button.setOnClickListener {
            tradeStandardIndex = 2
            setButton(standard1Button, 1, 0)
            setButton(standard2Button, 0, buySellIndex + 1)
        }

        setAmountButton.setOnClickListener {
            amountIndex = 1
            setCheckButton(setAmountButton, buySellIndex + 1)
            setCheckButton(setRateButton, 0)
            setAddButton()
        }

        setRateButton.setOnClickListener {
            amountIndex = 2
            setCheckButton(setAmountButton, 0)
            setCheckButton(setRateButton, buySellIndex + 1)
            setAddButton()
        }

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        val rootView = findViewById<View>(android.R.id.content)
        rootView.post {
            setFragment()
        }
    }

    private fun setButtonColor() {
        if (buySellIndex == 0) {
            setButton(buyButton, 0, 1)
            setButton(sellButton, 1, 0)

            setButton(rateButton, 1, 0)
            setButton(targetButton, 1, 0)
            setButton(tradingButton, 1, 0)

            when (standardIndex) {
                0 -> setButton(rateButton, 0, 1)
                1 -> setButton(targetButton, 0, 1)
                2 ->setButton(tradingButton, 0, 1)
            }
        }
        else {
            setButton(buyButton, 1, 0)
            setButton(sellButton, 0, 2)

            setButton(rateButton, 1, 0)
            setButton(targetButton, 1, 0)
            setButton(tradingButton, 1, 0)

            when (standardIndex) {
                0 -> setButton(rateButton, 0, 2)
                1 -> setButton(targetButton, 0, 2)
                2 ->setButton(tradingButton, 0, 2)
            }
        }

        if (amountIndex == 1) setCheckButton(setAmountButton, buySellIndex + 1)
        if (amountIndex == 2) setCheckButton(setRateButton, buySellIndex + 1)
        if (tradeStandardIndex == 1) setButton(standard1Button, 0, buySellIndex + 1)
        if (tradeStandardIndex == 2) setButton(standard2Button, 0, buySellIndex + 1)
        optionIndex = 0
        setAddButton()
    }

    private fun setButton(button: Button, text: Int, background: Int) {
        button.setBackgroundResource(backgroundColor[background])
        button.setTextColor(ContextCompat.getColor(this, textcolor[text]))
    }

    private fun setCheckButton(button: Button, background: Int) {
        button.setBackgroundResource(checkBoxColor[background])
    }

    private fun setFragment() {
        val index:Int = buySellIndex*10 + standardIndex

        when (index) {
            0 -> supportFragmentManager.beginTransaction()
                .replace(container.id, BuyRateFragment())
                .commitNow()
            1 -> supportFragmentManager.beginTransaction()
                .replace(container.id, BuyTargetFragment())
                .commitNow()
            2 -> supportFragmentManager.beginTransaction()
                .replace(container.id, BuyTradingFragment())
                .commitNow()
            10 -> supportFragmentManager.beginTransaction()
                .replace(container.id, SellRateFragment())
                .commitNow()
            11 -> supportFragmentManager.beginTransaction()
                .replace(container.id, SellTargetFragment())
                .commitNow()
            12 -> supportFragmentManager.beginTransaction()
                .replace(container.id, SellTradingFragment())
                .commitNow()
        }

        val fragment = supportFragmentManager.findFragmentById(container.id)
        fragment?.view?.let { fragmentView ->

            val option1Button = fragmentView.findViewById<Button>(R.id.set_option1_button)
            val option2Button = fragmentView.findViewById<Button>(R.id.set_option2_button)

            option1Button.setOnClickListener {
                optionIndex = 1
                setCheckButton(option1Button, buySellIndex + 1)
                setCheckButton(option2Button, 0)
                setAddButton()
            }

            option2Button.setOnClickListener {
                optionIndex = 2
                setCheckButton(option1Button, 0)
                setCheckButton(option2Button, buySellIndex + 1)
                setAddButton()
            }
        }
    }

    private fun setAddButton() {
        if (optionIndex != 0 && amountIndex != 0 && tradeStandardIndex != 0)
            setButton(addButton, 0, buySellIndex + 1)
        else
            setButton(addButton, 1, 0)
    }
}