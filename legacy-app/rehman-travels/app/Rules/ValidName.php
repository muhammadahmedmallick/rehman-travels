<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;

class ValidName implements Rule
{
    protected $forField;
    private $invalid;

    protected $invalidKeywords = [
        'test', 'testing', 'tester', 'testuser', 'testname', 'testaccount', 't3st', 'tst', 'demo', 'demouser', 'demo123', 'demotest',
        'example', 'sample', 'samples', 'mock', 'mockuser', 'temp', 'temporary', 'tmp', 'tempperson', 'tempguy',
        'name', 'realname', 'yourname', 'firstname', 'lastname', 'fullname', 'noname', 'nobody', 'myname', 'anyname',
        'first', 'last', 'someguy', 'somegirl', 'justme', 'whoami', 'user', 'username', 'us3r', 'user1', 'user123', 'userabc', 'userxyz',
        'admin', 'adm1n', 'admin1', 'admin123', 'administrator', 'superuser', 'sysadmin', 'root', 'guest', 'guest123', 'support', 'helpdesk', 'system', 'backend',
        'null', 'undefined', 'none', 'void', 'nil', 'n/a', 'n$a', 'blank', 'default', 'nothing', 'noone', 'unknown', 'unset',
        'asdf', 'qwerty', 'zxcv', 'dfg', 'ghj', 'lkh', 'mnb', 'poi', 'yui', 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg', 'hhh', 'iii',
        'jjj', 'kkk', 'lll', 'mmm', 'nnn', 'ooo', 'ppp', 'qqq', 'rrr', 'sss', 'ttt', 'uuu', 'vvv', 'www', 'xxx', 'yyy', 'zzz', 'abc', 'xyz', 'lmn', 'uvw', 'abcabc', 'xyzxyz',
        '000', '0000', '00000', '000abc', '111', '1111', '11111', '123', '1234', '12345', '23456', '34567', '45678', '56789',
        '9876', '999', '9999', '99999', 'fake', 'faker', 'fakename', 'fakename1', 'dummy', 'bogus', 'random', 'notreal', 'try', 'tryagain', 'lorem', 'ipsum', 'dolor', 'sit', 'amet',
        'bot', 'robot', 'robo', 'auto', 'automation', 'script', 'crawler', 'spider', 'aiuser', 'botuser', 'l33t', 'leet', 'h4x0r', 'pwn', 'n00b', 'noob', 'adm1n', 'us3r', 't3st', 's4mpl3',
        'abab', 'baaba', 'cdc', 'dad', 'efe', 'gogogo', 'hahaha', 'hehe', 'lol', 'omg', 'wtf', 'wtfuser',
        'john', 'johnny', 'johndoe', 'john doe', 'jon', 'joe', 'jane', 'janedoe', 'jane doe', 'smith', 'doe', 'miller', 'jack', 'jill',
        'anon', 'anonymous', 'whoknows', 'idk', 'notsure', 'someone', 'anyone', 'somebody', 'nameless', 'namer', 'abc123', 'xyz123', 'name123', 'user123', 'admin123', 'test123',
        'name1', 'name2', 'name3', 'test1', 'test2', 'user000', 'abc000', 'zzz999', 'mrtest', 'mr user', 'ms test', 'fakeperson', 'invalid', 'notvalid', 'garbage', 'trash', 'nonsense', 'nopename',
        'email', 'contact', 'address', 'password', 'login', 'testeraccount', 'notavailable', 'n/a', 'realuser', 'thisguy',
        'tesst', 'teest', 'tst', 't.est', 'test.', 't3st', 't3sting', 't3ster', 'te$t', 'userr', 'usr', 'uuser', 'user_', '_user', 'us3r', 'us.er', 'adm', 'adm1n', 'adm.in', 'd3mo', 'd3m0', 'demo_', 'd.e.m.o', 'n4me', 'naame', 'nmae', 'namme', 'n.ame', 'f4ke', 'fak3', 'fa.ke', 'f4k3name',
        'defaultuser', 'siteadmin', 'newuser', 'placeholder', 'defaultname', 'cmsuser', 'author', 'moderator', 'superadmin', 'systemuser', 'systemadmin', 'defaultaccount',
        'autobot', 'chatbot', 'aiuser', 'gptuser', 'spambot', 'botname', 'crawlerbot', 'scriptuser', 'tooluser', 'autofill', 'autoform', 'autogenerate', 'robotuser',
        'unknownperson', 'someoneelse', 'randomguy', 'girl123', 'fakeidentity', 'aliasuser', 'hacker', 'stealer', 'spy', 'guestlogin', 'incognito', 'ghostuser', 'cloneuser',
        'testtest', 'demoaccount', 'testaccount1', 'abcabc', 'zzzxxx', 'asdfgh', 'blabla', 'nananana', 'yooyooyoo', 'yada', 'whatever', 'dontcare', 'nvm',
        'marketing', 'sales', 'newsletter', 'signup','contact','webadmin', 'webmaster', 'info', 'supportteam', 'servicedesk', 'noreply',
        'user0001', 'user0002', 'guest001', 'guest007', 'admin007', 'temp1234', 'test9999', 'demo0000', 'temp9999', 'bot0001', 'bot9999', 'anon999', 'anon123', 'testabc',
    ];

    public function __construct($forField = 'name')
    {
        $this->forField = $forField;
    }

    public function passes($attribute, $value)
    {
        $valueLower = strtolower(trim($value));
        foreach ($this->invalidKeywords as $keyword):
            if (strpos($valueLower, $keyword) !== false):
                $this->invalid = $valueLower ?? '';
                return false;
            endif;
        endforeach;
        if (preg_match('/\d/', $value)):
            $this->invalid = $value;
            return false;
        endif;
        if (!preg_match('/^[a-zA-Z\s\-]+$/', $value)):
            $this->invalid = $value;
            return false;
        endif;
        if (strlen($value) < 2):
            $this->invalid = $value;
            return false;
        endif;
        return true;
    }


    public function message()
    {
        return "The {$this->forField} {$this->invalid} appears invalid or fake. Please enter a real name.";
    }
}
