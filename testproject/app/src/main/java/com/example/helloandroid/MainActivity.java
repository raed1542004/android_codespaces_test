package com.example.helloandroid;

import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

/**
 * MainActivity - تطبيق Hello World جاهز
 *
 * مواضيع المساق المدعومة في هذا المشروع:
 * - 1.1, 1.2: Fragments (انظر مجلد fragments/)
 * - 2.1: Menus (انظر res/menu/)
 * - 2.2: User Navigation (انظر res/navigation/)
 * - 3.1: Drawables, styles, themes (انظر res/values/themes.xml)
 * - 3.2: Material Design (مفعّل في build.gradle)
 * - 3.3: Adaptive layouts (انظر res/layout-sw600dp/)
 * - 4.1: AsyncTask (انظر async/)
 * - 4.2: Internet (أذونات مفعّلة)
 * - 4.3: Broadcasts (انظر receivers/)
 * - 4.4: Services (انظر services/)
 * - 5.1: Notifications (إذن مفعّل)
 * - 6.1: Firebase (معطل - فعّله من build.gradle)
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView welcomeText = findViewById(R.id.welcome_text);
        welcomeText.setText("Hello Android!\nمن GitHub Codespaces\nمساق Android Studio");
    }
}
