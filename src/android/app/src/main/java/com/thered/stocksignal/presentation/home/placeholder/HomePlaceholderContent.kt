package com.thered.stocksignal.presentation.home.placeholder

import com.thered.stocksignal.domain.entites.Stock
import com.thered.stocksignal.domain.entites.StockListWithTime
import java.util.ArrayList
import java.util.HashMap

/**
 * Helper class for providing sample content for user interfaces created by
 * Android template wizards.
 *
 * TODO: Replace all uses of this class before publishing your app.
 */
object HomePlaceholderContent {

    /**
     * An array of sample (placeholder) items.
     */
    val ITEMS: MutableList<PlaceholderItem> = ArrayList()

    var data: MutableList<Stock> = arrayListOf()
    /**
     * A map of sample (placeholder) items, by ID.
     */
    val ITEM_MAP: MutableMap<String, PlaceholderItem> = HashMap()

    init {
        data.forEachIndexed { index, stock ->
            addItem(createPlaceholderItem(index+1,stock))
        }
    }

    fun setItem(stockList: List<Stock>) {
        stockList.forEachIndexed { index, stock ->
            addItem(createPlaceholderItem(index+1, stock))
        }
    }

    private fun addItem(item: PlaceholderItem) {
        ITEMS.add(item)
        ITEM_MAP.put(item.id, item)
    }

    fun createPlaceholderItem(index:Int, stock: Stock): PlaceholderItem {
        val r = ((stock.currentPrice - stock.avgPrice).toFloat() / stock.avgPrice) * 100
        val formattedNumber = String.format("%,d", stock.currentPrice)
        var formattedRate = String.format("%.1f", r) + "%"
        if (formattedRate[0] != '-')
            formattedRate = "+" + formattedRate

        return PlaceholderItem(index.toString(), stock.stockName, formattedNumber, formattedRate, stock.logoImage, makeDetails(index))
    }

    private fun makeDetails(position: Int): String {
        val builder = StringBuilder()
        builder.append("Details about Item: ").append(position)
        for (i in 0..position - 1) {
            builder.append("\nMore details information here.")
        }
        return builder.toString()
    }

    /**
     * A placeholder item representing a piece of content.
     */
    data class PlaceholderItem(val id: String, val content: String, val price:String, val earnRate: String, val imgUrl: String, val details: String) {
        override fun toString(): String = content
    }
}