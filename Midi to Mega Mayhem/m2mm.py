import os
import pretty_midi
import librosa

#Put every possible note that BF can sing in Mega Mayhem into sorted "arrays".
A_Notes = "C4, E4, G♯4, A♯4, D♯5, G5, D6, D♯6"
E_Notes = "B4, C5, G♯5, E6, F6"
I_Notes = "C♯4, D♯4, G4, D5, F5, A♯5, C6"
O_Notes = "F4, A4, E5"
U_Notes = "D4, F♯4, C♯5 F♯5, A5, B5, C♯6, F♯6"

#Compare the current note of the midi file with the Vowel Arrays, and return any matching Note Vowels, if the range is too high or low, default to "a".
def GetFNFLyric(notename):
    if notename in A_Notes:
        return "a"
    elif notename in E_Notes:
        return "e"
    elif notename in I_Notes:
        return "i"
    elif notename in O_Notes:
        return "o"
    elif notename in U_Notes:
        return "u"
    else:
        return "a"

#clear out the notes file before appending data to it
open('notes.txt', 'w').close()

#open the vocal midi file
midi_data = pretty_midi.PrettyMIDI("vocals.mid")

#this is the fucking awful ass main loop
with open('notes.txt', 'w', encoding='UTF-16') as f:
    for instrument in midi_data.instruments: #open any channels in the midi, FUCKS UP HARD if there are more than one channel but who would do that for FNF vocals???
        for note in instrument.notes: #run the following code for every note found in the current channel
            print(GetFNFLyric(librosa.midi_to_note(note.pitch))) #print out the vowel into the terminal
            f.write(GetFNFLyric(librosa.midi_to_note(note.pitch))) #append the vowel to a text file
            f.write(" ") #add a space between the vowels for compliancy

#save the text file
f.close