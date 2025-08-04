package com.parcel.listeners;

import javax.servlet.*;
import javax.servlet.annotation.WebListener;
import java.util.*;

@WebListener
public class TimeZoneListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent sce) {
        // Set the default time zone for the entire application
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
    }

    public void contextDestroyed(ServletContextEvent sce) {
        // Optionally clean up when the application is destroyed
    }
}
