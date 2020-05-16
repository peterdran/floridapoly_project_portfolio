package edu.floridapoly.cop4656.spring19.dranishnikov;
/*     Second activity will have the following UI elements:
 *         A TextView that user can enter the note. This textview will initially have the following message; ‘Hello your name, please enter your note’ (10 points)
 *         A ‘Save’ button: Once ‘Save’ button is pressed, it will check what was entered and if nothing is entered, it will give the message, ‘Nothing entered yet’ and will not do anything else.
 *         If something was entered, second act will pass the value, that was entered, back to the first activity. First activity will display the value (as a toast message) that was received from the second activity. (30 points)
 *         A ‘Cancel’ button: Once ‘Cancel’ button is pressed; second activity will be closed without any checks. (10 points)
 */

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class NoteEntryActivity extends AppCompatActivity
{
//    private Note newNote;
    public static final String EXTRA_NOTE_ENTRY = "note_entry";
    private static final String EXTRA_NOTE_NAME = "note_name";
    private Button mSaveButton;
    private Button mCancelButton;
    private EditText mNoteInputText;

    public static Intent newIntent(Context packageContext, String in)
    {
        Intent intent = new Intent(packageContext, NoteEntryActivity.class);
        intent.putExtra(EXTRA_NOTE_NAME, in);
        return intent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_entry);

        mNoteInputText = (EditText) findViewById(R.id.note_text_entry);
        mCancelButton = (Button) findViewById(R.id.cancel_button);
        mSaveButton = (Button) findViewById(R.id.save_button);



        mCancelButton.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                finish();
            }
        });
        mSaveButton.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Intent data = new Intent();
                String note_text = mNoteInputText.getText().toString();
                if(note_text.isEmpty())
                {
                    Toast.makeText(NoteEntryActivity.this, "Nothing entered Yet", Toast.LENGTH_SHORT).show();
                }
                else
                {
                    data.putExtra(EXTRA_NOTE_ENTRY, note_text);
                    setResult(RESULT_OK, data);
                    finish();
                }
            }
        });
    }
}
