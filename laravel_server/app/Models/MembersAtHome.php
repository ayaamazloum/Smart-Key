<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MembersAtHome extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'arduino_id'];
}
