
Description:

    Here is a script i wrote that lets you use tab-completion using player
    names for any command that takes a client-number.

    Basically, you create a wrapper-command that calls the real command. On
    this wrapper you can use the completion.

    The completion lists the names of connected players as follows: 

        playername~<cn>

    The wrapper then cuts everything including the last ~ from the first
    argument and uses the remainder as the argument for the real command.

    You can add additional arguments after that. They are passed directly to
    the real command.

How to install:

    First, you need to load the file from your autoexec.cfg. To do this, copy
    playernamecomplete.cfg beneath your autoexec.cfg. Then add this preferably
    to the top of your autexec.cfg: 

        exec "playernamecomplete.cfg"

    Second, i suggest you to create a function in your autoexec.cfg that
    updates the completion lists. See "Usage" below on how the command works.
    Example:

        updatecompletion = [
            // use /f for /follow, completes non-spectators, and excludes the
            // currently followed one
            playernamecomplete f    follow   "SF"
            // use /ig for /ignore, completes non-ignored players, excludes
            // the player himself
            playernamecomplete ig   ignore   "PI"
        ]

    Third, you need to bind a key to call this function before you enter the
    prompt. You can override T if you want, i use CARET (^):

        bind CARET [ updatecompletion; saycommand / ]

    Now, CARET updates the completion and then shows a prompt with a "/"
    already inserted. If you don't want this, remove the / after saycommand.
    This bind only works when in game, to use it as spectator and in edit
    mode, you need to insert this:

        specbind CARET [ updatecompletion; saycommand / ]
        editbind CARET [ updatecompletion; saycommand / ]

Usage:

    /playernamecomplete <ALIAS> <COMMAND> [<FLAGS>] [<ARGNUM>]

    Create wrapper <ALIAS> which calls <COMMAND> supporting tab-completion of
    connected players.

    <FLAGS> are there to specify which players appear in the list.
    Every character is a condition that is checked when the list is created.
    When all are true, the player is included.
    Example: "SF" - S: excludes spectators
                    F: excludes the currently spectated player
    A List of all flags can be found below.

    <ARGNUM> tells the wrapper which argument the client number should be
    passed to. This is needed because you can only use completion on the first
    argument of the wrapper. If this is not specified, 1 is used.

    The command is then called like so: /command $arg2 $arg3 $cn $arg4
    If you pass less than <ARGNUM> arguments to the wrapper, empty arguments
    (like "") are inserted before $cn.

Notes:

    The player names are cleaned from invalid or hard to type characters using
    a whitelist. After that, they are transformed to lower casee, which makes
    typing easier.

    Completion also works when the player name contains the delimiter, since
    the last occurrence of the delimiter is used.
    You can also just type the cn without a name, since nothing is cut when
    there is no delimiter.

    You can change the whitelist of characters by editing _pnc_allowedchars at
    the top of the script.

List of flags:

    s/S  -  spectator/not spectator
    b/B  -  bot/not bot
    i/I  -  ignored/not ignored
    e/E  -  enemy/not enemy
    p/P  -  current player/not current player
    f/F  -  followed player/not followed player
    m/M  -  master or admin/not master and not admin
    a/A  -  admin/not admin
    l/L  -  lower privilege/equal or higher privilege than player
    h/H  -  higher privilege/equal or lower privilege than player

/* vim:set sw=4 ts=4 sts=0 ft=text et:*/
