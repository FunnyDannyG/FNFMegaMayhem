import flixel.FlxG;
import flixel.FlxSprite;

class Ratings
{

static var combocount = 0;

    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "N/A";
		if(FlxG.save.data.botplay)
			ranking = "BotPlay";

        if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
            ranking = "(APFC)";
        else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
            ranking = "(GFC)";
        else if (PlayState.misses == 0) // Regular FC
            ranking = "(FC)";
        else if (PlayState.misses < 10) // Single Digit Combo Breaks
            ranking = "(Good)";
        else
            ranking = "(Clear)";

        // WIFE TIME :)))) (based on Wife3)

        var wifeConditions:Array<Bool> = [
            accuracy >= 99.9935, // AAAAA
            accuracy >= 99.980, // AAAA:
            accuracy >= 99.970, // AAAA.
            accuracy >= 99.955, // AAAA
            accuracy >= 99.90, // AAA:
            accuracy >= 99.80, // AAA.
            accuracy >= 99.70, // AAA
            accuracy >= 99, // AA:
            accuracy >= 96.50, // AA.
            accuracy >= 93, // AA
            accuracy >= 90, // A:
            accuracy >= 85, // A.
            accuracy >= 80, // A
            accuracy >= 70, // B
            accuracy >= 60, // C
            accuracy < 60 // D
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " How";
                    case 1:
                        ranking += " God 2";
                    case 2:
                        ranking += " God";
                    case 3:
                        ranking += " SSS+";
                    case 4:
                        ranking += " SSS";
                    case 5:
                        ranking += " SSS-.";
                    case 6:
                        ranking += " SS+";
                    case 7:
                        ranking += " SS";
                    case 8:
                        ranking += " SS-";
                    case 9:
                        ranking += " S+";
                    case 10:
                        ranking += " S";
                    case 11:
                        ranking += " S-";
                    case 12:
                        ranking += " A";
                    case 13:
                        ranking += " B";
                    case 14:
                        ranking += " C";
                    case 15:
                        ranking += " You Fucking Suck";
                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "N/A";
		else if(FlxG.save.data.botplay)
			ranking = "BotPlay";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;


        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

	if (FlxG.save.data.botplay)
	    return "sick"; // FUNNY
	    
        if (noteDiff > 166 * customTimeScale) // so god damn early its a miss
            return "miss";
        if (noteDiff > 135 * customTimeScale) // way early
            {
            return "shit";
            }
        else if (noteDiff > 90 * customTimeScale) // early
            {
            return "bad";
            }
        else if (noteDiff > 45 * customTimeScale) // your kinda there
            {
            return "good";
            }
        else if (noteDiff < -45 * customTimeScale) // little late
            {
            return "good";
            }
        else if (noteDiff < -90 * customTimeScale) // late
            {
            return "bad";
            }
        else if (noteDiff < -135 * customTimeScale) // late as fuck
            {
            return "shit";
             }
        else if (noteDiff < -166 * customTimeScale) // so god damn late its a miss
            return "miss";
        return "sick";
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,accuracy:Float,combocount:Int):String
    {
        return 
        "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 	
        " | Accuracy:" + (FlxG.save.data.botplay ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %") +
        " | Misses:" + PlayState.misses +
        " | Combo:" + (combocount);								
    }
}