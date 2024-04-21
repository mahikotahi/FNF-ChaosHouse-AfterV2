package;

import sys.io.File;
import sys.FileSystem;

using StringTools;

class ImageLoadingState extends MusicBeatState
{
    public static var filesToRead:Array<String> = [];
    public static var filePaths:Array<String> = [];
    
	public static function readFiles()
	{
		filesToRead = [];
		filePaths = [];

		read('assets');
        read('mods');

        //trace(filesToRead);
        for (i in 0...filesToRead.length) {

            var cooltype:String = 'UFT';

            cooltype = checkFileEnding('.png', filesToRead[i], 'Image');
            cooltype = checkFileEnding('.json', filesToRead[i], 'JSON');
            cooltype = checkFileEnding('.lua', filesToRead[i], 'Lua');
            cooltype = checkFileEnding('.xml', filesToRead[i], 'XML');
            cooltype = checkFileEnding('.ogg', filesToRead[i], 'Sound');
            cooltype = checkFileEnding('.mp3', filesToRead[i], 'Sound');
            cooltype = checkFileEnding('.mp4', filesToRead[i], 'Video');
            cooltype = checkFileEnding('.txt', filesToRead[i], 'Text');
            cooltype = checkFileEnding('.ttf', filesToRead[i], 'Font');
            cooltype = checkFileEnding('.otf', filesToRead[i], 'Font');

            if (cooltype == null) cooltype = 'UFT';

            var cooltrace:String = 'File: '+filePaths[i] +'/'+filesToRead[i];


            //if (cooltrace.contains('data/menu/'))trace(cooltrace);

            // rip caching code
        }
	}

    public static function checkFileEnding(ending:String = '.png', file:String = 'coolswag.png', returnType:String = 'image')
    {
        if (Std.string(file).endsWith(ending)) {/*trace('work $returnType!');*/return returnType;}

        return 'UFT';
    }

    public static function read(epicfolder:String = 'assets')
    {
        try
            {
                for (folder in FileSystem.readDirectory('${epicfolder}'))
                {
                    //trace('${epicfolder}/' + FileSystem.readDirectory('${epicfolder}/' + folder));
    
                    try
                    {
                        for (otherfolder in FileSystem.readDirectory('${epicfolder}/${folder}'))
                        {
                            if (FileSystem.readDirectory('${epicfolder}/' + folder + '/' + otherfolder) != null)
                            {
                                if (FileSystem.readDirectory('${epicfolder}/' + folder + '/' + otherfolder) != null)
                                    //trace('${epicfolder}/' + folder + '/' + otherfolder+'/' + FileSystem.readDirectory('${epicfolder}/' + folder + '/' + otherfolder));
    
                                if (!otherfolder.contains('.'))
                                {
                                    try
                                    {
                                        for (otherotherfolder in FileSystem.readDirectory('${epicfolder}/${folder}/${otherfolder}'))
                                        {
                                            if (FileSystem.readDirectory('${epicfolder}/' + folder + '/' + otherfolder + '/' + otherotherfolder) != null)
                                            {
                                                //trace('${epicfolder}/' + folder + '/' + otherfolder+'/${otherotherfolder}/' + FileSystem.readDirectory('${epicfolder}/' + folder + '/' + otherfolder + '/' + otherotherfolder));
    
                                                var coolfolder:Array<Dynamic> = FileSystem.readDirectory('${epicfolder}/${folder}/${otherfolder}/'+otherotherfolder);
    
                                                for (i in 0...coolfolder.length)
                                                {
                                                    //trace('Loaded: '+coolfolder[i]);
                                                    //trace(coolfolder[i]);
                                                    filesToRead.push(Std.string(coolfolder[i]));
                                                    filePaths.push(Std.string('${epicfolder}/${folder}/${otherfolder}/'+otherotherfolder));
                                                }
                                            }
                                        }
                                    }
                                    catch (e:Dynamic)
                                    {
                                        //trace(e);
                                    }
                                }
                                else
                                {
                                    var coolfolder:Array<Dynamic> = FileSystem.readDirectory('${epicfolder}/${folder}/${otherfolder}');
    
                                    for (i in 0...coolfolder.length)
                                    {
                                       // trace('Loaded: '+coolfolder[i]);
                                        filesToRead.push(Std.string(coolfolder[i]));
                                        filePaths.push(Std.string('${epicfolder}/${folder}/${otherfolder}'));
                                    }
                                }
                            }
                        }
                    }
                    catch (e:Dynamic)
                    {
                        //trace(e);
                    }
                }
            }
            catch (e:Dynamic)
            {
                //trace(e);
            }
    }
}
