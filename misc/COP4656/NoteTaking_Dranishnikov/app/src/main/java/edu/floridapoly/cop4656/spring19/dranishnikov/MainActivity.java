package edu.floridapoly.cop4656.spring19.dranishnikov;
/*
 * Your goal is to develop an Android Note Taking app. With each individual assignment, this app will grow and become a better note taking app.
 * In this first assignment, you are supposed to complete the following tasks:
 *
 *     Your first (main) screen will have the following UI elements:
 *         A TextView that has your first name and last name (10 points)
 *         A TextView that has your ID (5 points)
 *         First name, last name and ID should come from the strings.xml file (10 points)
 *         A button to add new notes. When clicked, it starts another activity to create a note. The main activity will also pass your name to the second activity. (15 points)
 *
 *     Second activity will have the following UI elements:
 *         A TextView that user can enter the note. This textview will initially have the following message; ‘Hello your name, please enter your note’ (10 points)
 *         A ‘Save’ button: Once ‘Save’ button is pressed, it will check what was entered and if nothing is entered, it will give the message, ‘Nothing entered yet’ and will not do anything else.
 *         If something was entered, second act will pass the value, that was entered, back to the first activity. First activity will display the value (as a toast message) that was received from the second activity. (30 points)
 *         A ‘Cancel’ button: Once ‘Cancel’ button is pressed; second activity will be closed without any checks. (10 points)
 *
 *
 * What to submit: A zip file containing the followings (not submitting any of the followings might cause to get 0 from the assignment):
 *
 *     Zip file of your project that you will get by using ‘Export to Zip file’ option from the File menu. (zipped file size should not exceed 1 MB)
 *     Debug apk (app-debug.apk) of your project (generally found in the app\build\outputs\apk folder under project)
 *     A video in mp4 format (max 30 seconds) that shows how your app works
 */

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity
{
    private Button mCreateNote;
    private static final int REQUEST_CODE_NOTE_ENTRY = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        mIntroNameTextView = (TextView) findViewById(R.id.user_name_intro);
//        mIntroIDTextView = (TextView) findViewById(R.id.poly_id_intro);

        mCreateNote = (Button) findViewById(R.id.note_create_button);
        mCreateNote.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                String name = getString(R.string.first_name) + " " + getString(R.string.last_name);
                Intent intt = NoteEntryActivity.newIntent(MainActivity.this, name);
                startActivityForResult(intt, REQUEST_CODE_NOTE_ENTRY);
            }
        });


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
//        super.onActivityResult(requestCode, resultCode, data);
//        Log.e("CALLED", "OnActivity Result");
//        Log.e("REQCODE", Integer.toString(requestCode));
        if (resultCode != RESULT_OK) {
            return;
        }

        if (requestCode == REQUEST_CODE_NOTE_ENTRY) {
            if (data == null) {
                return;
            }
//            Log.e("REACHED","toast logic");
            Toast.makeText(MainActivity.this, data.getStringExtra("note_entry"), Toast.LENGTH_LONG).show();
        }
    }
}
