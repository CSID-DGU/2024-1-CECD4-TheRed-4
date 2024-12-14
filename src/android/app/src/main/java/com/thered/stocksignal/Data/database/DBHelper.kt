import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import com.thered.stocksignal.domain.entites.Stock
import com.thered.stocksignal.domain.entites.StockBalanceWithTime
import com.thered.stocksignal.domain.entites.StockList
import com.thered.stocksignal.domain.entites.StockListWithTime
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DBHelper(
    val context: Context?,
) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {
    companion object{
        const val DATABASE_VERSION = 1
        const val DATABASE_NAME = "INNER_DATABASE"
        const val UID = "UID"

        // MY_INFO TABLE
        const val MY_INFO_TABLE_NAME = "MY_INFO"
        const val MY_INFO_NICKNAME = "NICKNAME"
        const val MY_INFO_IS_CONNECTED = "IS_CONNECTED"

        // FAVORITE TABLE
        const val FAVORITE_TABLE_NAME = "FAVORITE"
        const val FAVORITE_UPDATE_TIME = "UPDATE_TIME"
        const val FAVORITE_STOCK_LIST_INDEX = "STOCK_LIST_INDEX"

        // MY_STOCK TABLE
        const val MY_STOCK_TABLE_NAME = "MY_STOCK"
        const val MY_STOCK_UPDATE_TIME = "UPDATE_TIME"
        const val MY_STOCK_CASH = "CASH"
        const val MY_STOCK_TOTAL_STOCK_PRICE = "TOTAL_STOCK_PRICE"
        const val MY_STOCK_TOTAL_STOCK_PL = "TOTAL_STOCK_PL"

        const val MY_STOCK_STOCK_LIST_INDEX = "STOCK_LIST_INDEX"

        // STOCK_LIST_INDEX TABLE
        const val STOCK_LIST_INDEX_TABLE_NAME = "STOCK_LIST_INDEX"
        const val STOCK_LIST_INDEX = "LIST_INDEX"
        const val STOCK_LIST_INDEX_CODE = "CODE"

        // STOCK TABLE
        const val STOCK_TABLE_NAME = "STOCK"
        const val STOCK_TABLE_TITLE = "TITLE"
        const val STOCK_TABLE_IMG_URL = "IMG_URL"
        const val STOCK_TABLE_PRICE = "PRICE"
        const val STOCK_TABLE_START_PRICE = "START_PRICE"

        // BALANCE TABLE
        const val BALANCE_TABLE_NAME = "BALANCE"
        const val BALANCE_CODE = "CODE"
        const val BALANCE_QUANTITY = "QUANTITY"
        const val BALANCE_AVG_PRICE = "AVG_PRICE"
    }

    override fun onCreate(db: SQLiteDatabase) {

        val createMyInfoTable = """
            CREATE TABLE IF NOT EXISTS $MY_INFO_TABLE_NAME (
                $UID integer primary key autoincrement, 
                $MY_INFO_NICKNAME text,
                $MY_INFO_IS_CONNECTED boolean);
                """.trimIndent()

        val createFavoriteTable = """
            CREATE TABLE IF NOT EXISTS $FAVORITE_TABLE_NAME (
                $UID integer primary key autoincrement, 
                $FAVORITE_STOCK_LIST_INDEX integer unique,
                $FAVORITE_UPDATE_TIME text 
                );
                """.trimIndent()

        val createMyStockTable = """
            CREATE TABLE IF NOT EXISTS $MY_STOCK_TABLE_NAME ( 
                $UID integer primary key autoincrement, 
                $MY_STOCK_UPDATE_TIME text, 
                $MY_STOCK_CASH integer,
                $MY_STOCK_TOTAL_STOCK_PRICE integer,
                $MY_STOCK_TOTAL_STOCK_PL integer,
                $MY_STOCK_STOCK_LIST_INDEX integer unique);
                """.trimIndent()

        val createListIndexTable = """
            CREATE TABLE IF NOT EXISTS $STOCK_LIST_INDEX_TABLE_NAME (
                $UID integer primary key autoincrement, 
                $STOCK_LIST_INDEX integer, 
                $STOCK_LIST_INDEX_CODE text,
                unique($STOCK_LIST_INDEX, $STOCK_LIST_INDEX_CODE));
                """.trimIndent()

        val createStockTable = """
            CREATE TABLE IF NOT EXISTS $STOCK_TABLE_NAME (
                $UID integer primary key autoincrement, 
                $STOCK_TABLE_TITLE text unique, 
                $STOCK_TABLE_IMG_URL text, 
                $STOCK_TABLE_PRICE integer, 
                $STOCK_TABLE_START_PRICE integer);
                """.trimIndent()

        val createBalanceTable = """
            CREATE TABLE IF NOT EXISTS $BALANCE_TABLE_NAME (
                $UID integer primary key autoincrement, 
                $BALANCE_CODE text unique,
                $BALANCE_QUANTITY integer,
                $BALANCE_AVG_PRICE integer);
                """.trimIndent()

        db.execSQL(createMyInfoTable)
        db.execSQL(createFavoriteTable)
        db.execSQL(createMyStockTable)
        db.execSQL(createListIndexTable)
        db.execSQL(createStockTable)
        db.execSQL(createBalanceTable)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {

        db.execSQL("DROP TABLE IF EXISTS $MY_INFO_TABLE_NAME")

        db.execSQL("DROP TABLE IF EXISTS $FAVORITE_TABLE_NAME")

        db.execSQL("DROP TABLE IF EXISTS $MY_STOCK_TABLE_NAME")

        db.execSQL("DROP TABLE IF EXISTS $STOCK_LIST_INDEX_TABLE_NAME")

        db.execSQL("DROP TABLE IF EXISTS $STOCK_TABLE_NAME")

        db.execSQL("DROP TABLE IF EXISTS $BALANCE_TABLE_NAME")

        onCreate(db)
    }

    @SuppressLint("Recycle", "Range")
    fun getFavoriteList(): StockListWithTime {
        val db = this.readableDatabase

        var timeLine: String
        var list = ArrayList<Stock>()

        val getTimeQueryHandler = "SELECT * FROM $FAVORITE_TABLE_NAME;"
        val timeCursor = db.rawQuery(getTimeQueryHandler, null)

        var exists = false
        if (timeCursor.moveToFirst()) {
            exists = timeCursor.getInt(0) == 1
        }
        if (exists)
        {
            timeLine = timeCursor.getString(timeCursor.getColumnIndex(FAVORITE_UPDATE_TIME))
            val getStocksQueryHandler = """
                SELECT * FROM $STOCK_TABLE_NAME 
                WHERE $STOCK_TABLE_TITLE 
                IN (SELECT $STOCK_TABLE_TITLE 
                FROM $STOCK_LIST_INDEX_TABLE_NAME 
                WHERE $STOCK_LIST_INDEX = 1);
            """.trimIndent()

            val stocksCursor = db.rawQuery(getStocksQueryHandler, null)
            if (stocksCursor.moveToFirst()){
                do{
                    val stock = Stock()
                    stock.stockName = stocksCursor.getString(stocksCursor.getColumnIndex(STOCK_TABLE_TITLE))
                    stock.logoImage = stocksCursor.getString(stocksCursor.getColumnIndex(STOCK_TABLE_IMG_URL))
                    stock.currentPrice = stocksCursor.getInt(stocksCursor.getColumnIndex(STOCK_TABLE_PRICE))
                    stock.avgPrice = stocksCursor.getInt(stocksCursor.getColumnIndex(STOCK_TABLE_START_PRICE))
                    list.add(stock)
                } while (stocksCursor.moveToNext())
            }
            stocksCursor.close()
        }
        else
        {
            timeLine = getTime()
        }
        timeCursor.close()

        val stockList = StockListWithTime(list, timeLine)
        db.close()

        return stockList
    }

    @SuppressLint("Recycle")
    fun setFavoriteList(stockList: StockListWithTime) {
        val db = this.writableDatabase

        val timeQuery = """
            INSERT OR REPLACE INTO $FAVORITE_TABLE_NAME ($FAVORITE_STOCK_LIST_INDEX, $FAVORITE_UPDATE_TIME) 
            VALUES (?, ?);
        """.trimIndent()
        db.execSQL(timeQuery, arrayOf(1, stockList.timeLine))

        stockList.stocks.forEach { stock ->

            val indexQuery = """
                INSERT OR REPLACE INTO $STOCK_LIST_INDEX_TABLE_NAME (
                $STOCK_LIST_INDEX,
                $STOCK_LIST_INDEX_CODE)
                VALUES (?, ?);
            """.trimIndent()

            val stockQuery = """
                INSERT OR REPLACE INTO $STOCK_TABLE_NAME (
                $STOCK_TABLE_TITLE,
                $STOCK_TABLE_IMG_URL,
                $STOCK_TABLE_PRICE,
                $STOCK_TABLE_START_PRICE)
                VALUES (?, ?, ?, ?, ?);
            """.trimIndent()

            db.execSQL(indexQuery, arrayOf(1, stock.stockName))
            db.execSQL(stockQuery, arrayOf(stock.stockName, stock.stockName, stock.logoImage, stock.currentPrice, stock.avgPrice))
        }
        db.close()
    }

    @SuppressLint("Recycle", "Range")
    fun getStockBalance(): StockBalanceWithTime {
        val db = this.readableDatabase


        var timeLine: String = ""
        var cash: Int = 0
        var totalStockPrice: Int = 0
        var totalStockPL: Int = 0
        val list = ArrayList<Stock>()

        val queryHandler = "SELECT * FROM $MY_STOCK_TABLE_NAME;"
        val cursor = db.rawQuery(queryHandler, null)

        var exists = false
        if (cursor.moveToFirst()) {
            exists = cursor.getInt(0) == 1
        }
        if (exists)
        {

            timeLine = cursor.getString(cursor.getColumnIndex(MY_STOCK_UPDATE_TIME))
            cash = cursor.getInt(cursor.getColumnIndex(MY_STOCK_CASH))
            totalStockPrice = cursor.getInt(cursor.getColumnIndex(MY_STOCK_TOTAL_STOCK_PRICE))
            totalStockPL = cursor.getInt(cursor.getColumnIndex(MY_STOCK_TOTAL_STOCK_PL))

            val getStocksQueryHandler = """
                SELECT * FROM $STOCK_TABLE_NAME 
                JOIN $BALANCE_TABLE_NAME
                ON $STOCK_TABLE_NAME.$STOCK_TABLE_TITLE = $BALANCE_TABLE_NAME.$BALANCE_CODE
                WHERE $STOCK_TABLE_NAME.$STOCK_TABLE_TITLE
                IN (SELECT $STOCK_TABLE_NAME.$STOCK_TABLE_TITLE
                FROM $STOCK_LIST_INDEX_TABLE_NAME 
                WHERE $STOCK_LIST_INDEX = 2);
            """.trimIndent()

            val stocksCursor = db.rawQuery(getStocksQueryHandler, null)
            if (stocksCursor.moveToFirst()){
                do{
                    val stock = Stock()
                    stock.stockName = stocksCursor.getString(stocksCursor.getColumnIndex(STOCK_TABLE_TITLE))
                    stock.quantity = stocksCursor.getInt(stocksCursor.getColumnIndex(BALANCE_QUANTITY))
                    stock.logoImage = stocksCursor.getString(stocksCursor.getColumnIndex(STOCK_TABLE_IMG_URL))
                    stock.avgPrice = stocksCursor.getInt(stocksCursor.getColumnIndex(BALANCE_AVG_PRICE))
                    stock.currentPrice = stocksCursor.getInt(stocksCursor.getColumnIndex(STOCK_TABLE_PRICE))
                    stock.avgPrice = stocksCursor.getInt(stocksCursor.getColumnIndex(STOCK_TABLE_START_PRICE))
                    list.add(stock)
                } while (stocksCursor.moveToNext())
            }
            stocksCursor.close()
        }
        else
        {
            timeLine = getTime()
        }
        cursor.close()

        val stockList = StockBalanceWithTime(list, cash, totalStockPrice, totalStockPL, timeLine)
        db.close()

        return stockList
    }

    @SuppressLint("Recycle")
    fun setStockBalance(stockBalance: StockBalanceWithTime) {
        val db = this.writableDatabase

        val query = """
            INSERT OR REPLACE INTO $MY_STOCK_TABLE_NAME ($MY_STOCK_UPDATE_TIME, $MY_STOCK_CASH, $MY_STOCK_TOTAL_STOCK_PRICE, $MY_STOCK_TOTAL_STOCK_PL, $MY_STOCK_STOCK_LIST_INDEX) 
            VALUES (?, ?, ?, ?, ?);
        """.trimIndent()
        db.execSQL(query, arrayOf(stockBalance.timeLine, stockBalance.totalStockPrice, stockBalance.totalStockPL, 2))

        stockBalance.stocks.forEach { stock ->

            val indexQuery = """
                INSERT OR REPLACE INTO $STOCK_LIST_INDEX_TABLE_NAME (
                $STOCK_LIST_INDEX,
                $STOCK_LIST_INDEX_CODE)
                VALUES (?, ?);
            """.trimIndent()

            val stockQuery = """
                INSERT OR REPLACE INTO $STOCK_TABLE_NAME (
                $STOCK_TABLE_TITLE,
                $STOCK_TABLE_IMG_URL,
                $STOCK_TABLE_PRICE,
                $STOCK_TABLE_START_PRICE)
                VALUES (?, ?, ?, ?);
            """.trimIndent()

            val balanceQuery = """
                INSERT OR REPLACE INTO $BALANCE_TABLE_NAME (
                $BALANCE_CODE,
                $BALANCE_QUANTITY,
                $BALANCE_AVG_PRICE)
                VALUES (?, ?, ?)
            """.trimIndent()

            db.execSQL(indexQuery, arrayOf(2, stock.stockName))
            db.execSQL(stockQuery, arrayOf(stock.stockName, stock.stockName, stock.logoImage, stock.currentPrice, stock.avgPrice))
            db.execSQL(balanceQuery, arrayOf(stock.stockName, stock.quantity, stock.avgPrice))
        }
        db.close()
    }

    fun getTime(): String {
        val now = Locale.getDefault()
        val currentTime = SimpleDateFormat("yy.MM.dd HH:mm", now).format(Date()).toString()
        return currentTime
    }

    @SuppressLint("Recycle", "Range")
    fun test() {
        var db = readableDatabase

        val query2 = """
            SELECT * FROM $FAVORITE_TABLE_NAME;
        """.trimIndent()

        val cursor = db.rawQuery(query2, null)
        if (cursor.moveToFirst()) {
            do {

            } while (cursor.moveToNext())
        }
        db.close()
    }

    fun databaseUpgrade() {
        onUpgrade(this.writableDatabase, 1, 2)

        val db = this.readableDatabase

        val cursor = db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null)

        if (cursor.moveToFirst()) {
            do {
                val tableName = cursor.getString(0)  // 첫 번째 열에 테이블 이름이 있습니다.
                Log.d("TableName", tableName)
            } while (cursor.moveToNext())
        }

        cursor.close()  // 커서를 닫아줍니다.
    }
}