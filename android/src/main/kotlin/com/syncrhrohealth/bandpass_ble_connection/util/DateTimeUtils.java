package com.syncrhrohealth.bandpass_ble_connection.util;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class DateTimeUtils {
    private static final String TAG = "DateTimeUtils";

    public interface onReceiveTrueTime {
        void trueTime(Long time);
    }

    public static long currentTimeToEpoch() {
        int offsetFromUtc = getOffsetFromUtc();
        Log.i(TAG, "currentTimeToEpoch: " + offsetFromUtc + ", " + System.currentTimeMillis());
        return (System.currentTimeMillis() / 1000 + offsetFromUtc);
    }

    public static int getEpochTimeInSec() {
        return (int) (System.currentTimeMillis() / 1000);
    }

    public static Long getEpochTimeInMillis() {
        return System.currentTimeMillis();
    }

    public static int getLocalTimeInDay() {
        return (int) ((currentTimeToEpoch() / (24 * 60 * 60)) * (24 * 60 * 60)) - getOffsetFromUtc();
    }

//    public static int convertTimeInDay(int secs) {
//        return (int) ((secs / (24 * 60 * 60)) * (24 * 60 * 60));
//    }

    public static int convertTimeInDay(int secs) {
        String epoch = new SimpleDateFormat("DD/MM/yyyy").format(new Date((long) secs * 1000));

        SimpleDateFormat iWanted = new SimpleDateFormat("DD/MM/yyyy");
        try {
            Date date = iWanted.parse(epoch);
            return (int) (date.getTime() / 1000);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static int convertTimeInMonth(int secs) {
        String epoch = new SimpleDateFormat("MM/yyyy").format(new Date((long) secs * 1000));

        SimpleDateFormat iWanted = new SimpleDateFormat("MM/yyyy");
        try {
            Date date = iWanted.parse(epoch);
            return (int) (date.getTime() / 1000);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static int getOffsetFromUtc() {
        TimeZone tz = TimeZone.getDefault();
        Date now = new Date();
        return tz.getOffset(now.getTime()) / 1000;
    }

    /**
     * Get current timezone of device
     *
     * @return
     */
    public static int getTimezoneInHour() {
        TimeZone tz = TimeZone.getDefault();
        Date now = new Date();
        int offsetFromUtc = tz.getOffset(now.getTime());

        return offsetFromUtc / 3600000;
    }

    /**
     * Get current timezone of device in minute
     *
     * @return
     */
    public static int getTimezoneInMinute() {
        TimeZone tz = TimeZone.getDefault();
        Date now = new Date();
        int offsetFromUtc = tz.getOffset(now.getTime());

        return offsetFromUtc / 60000;
    }

    public static String epochToString(long epoch, String format) {
        //Date date = new Date((epoch - offsetFromUtc) * 1000);
        Date date = new Date((epoch) * 1000);
        SimpleDateFormat s = new SimpleDateFormat(format);
        return s.format(date);
    }

    public static Date epochToDate(long epoch) {
        TimeZone tz = TimeZone.getDefault();
        Date now = new Date();
        int offsetFromUtc = tz.getOffset(now.getTime()) / 1000;

        Date date = new Date((epoch - offsetFromUtc) * 1000);
        return date;
    }

    public static String getRemaingTime(int minute) {
        int h = minute / 60;
        int m = minute % 60;

        if (minute == 0) {
            return "Fully Charged";
        }
        if (h == 0) {
            return String.format("%dm left", m);
        } else if (m == 0) {
            return String.format("%dh left", h);
        } else {
            return String.format("%dh %dm left", h, m);
        }
    }

    public static boolean isSameDate(long epoch1, long epoch2) {
        Date date1 = epochToDate(epoch1);
        Date date2 = epochToDate(epoch2);

        if (date1.getDate() == date2.getDate() &&
                date1.getMonth() == date2.getMonth() &&
                date1.getYear() == date2.getYear()) {
            return true;
        }

        return false;
    }

    /**
     * Get current time
     *
     * @param format Wanted format
     * @return
     */
    public static String getCurrentTime(String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.US);
        return sdf.format(new Date());
    }

    public static void getTrueTimeUTCInSecond(onReceiveTrueTime receiveTrueTime) {
        receiveTrueTime.trueTime(System.currentTimeMillis() / 1000);
//
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    TrueTime trueTime = TrueTime.build();
//                    trueTime.withNtpHost("time.google.com");
//                    trueTime.initialize();
//                    long utcZero = TrueTime.now().getTime() / 1000;
//                    receiveTrueTime.trueTime(utcZero);
//                } catch (IOException e) {
//                    e.printStackTrace();
//                    receiveTrueTime.trueTime(System.currentTimeMillis() / 1000);
//                }
//            }
//        }).start();
    }

    public static Long getEpochStartOfDay(int add) {
       Date date = getStartOfDay(addDay(new Date(), add));
       return date.getTime() + getOffsetFromUtc()*1000;
    }

    /**
     * Get epoch start of day in phone's timezone
     *
     * @param date to get start of day
     * @return Date
     */
    public static Date getStartOfDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    /**
     * Add a amount of day to Date
     * @param date
     * @param amount
     * @return
     */
    public static Date addDay(Date date, int amount) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_YEAR, amount);
        return calendar.getTime();
    }
}
