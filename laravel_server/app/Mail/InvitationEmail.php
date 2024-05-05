<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class InvitationEmail extends Mailable 
{
    use Queueable, SerializesModels;

    public $mail_message;
    
    /**
     * Create a new message instance.
     *
     * @param string $message
     */
    public function __construct($message)
    {
        $this->mail_message = $message;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->html($this->mail_message)
                    ->subject('Smart Key Invitation');
    }
}
