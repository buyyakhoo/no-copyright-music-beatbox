use_bpm 90

amp_snare = 0.9
amp_hat = 0.8

amp_pizz = 0.5
amp_piano = 0.9
amp_piano_co = 0.6

# beatbox sound from https://www.soundsnap.com/tags/beatbox

snare_sample = "D:/dev/Activity/StupidHack8/background-presentation-music/sample/15399-mouth_beat_box_-BD_3.wav"
hat_sample = "D:/dev/Activity/StupidHack8/background-presentation-music/sample/15816-mouth_beat_box_-HH_2.wav"


live_loop :met do
  sleep 1
end

# drum zone

all_drum_note = {
  "snare_note" => "x---x---x---x---x--xx--xx--xx--x",
  "hat_note" => "x-x-x-x-xxx-x-xx"
}

live_loop :snare, sync: :met do
  snare_note = all_drum_note["snare_note"].ring
  
  32.times do |i|
    #:drum_snare_soft
    sample snare_sample, amp: amp_snare + 0.3*(i/16).to_i if snare_note.tick == "x"
    sleep 0.25
  end
end

live_loop :hat, sync: :met do
  
  hat_note = all_drum_note["hat_note"].ring
  
  16.times do
    #:hat_psych
    sample hat_sample, amp: amp_hat if hat_note.tick == "x"
    sleep 0.25
  end
  
end

# synth zone
all_synth_note = {
  "pizz" => [:eb2, :f2, :g2, :c2, :g2, :f2, :c2, :b2, :bb2, :d2, :bb2],
  "piano" => [:bb5, :g5, :f5, :eb5, :f5, :g5, :ab5, :bb5],
  "piano_chord" => [chord(:Eb, :major7), chord(:C, :minor7), chord(:F, :minor7), chord(:Bb, "7")]
}

all_synth_sleep = {
  "pizz" => [1, 1, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5],
  "piano" => [1.5, 3, 1, 0.5, 0.5, 0.5, 0.25, 0.75],
  "piano_co" => [0.5, 0.25, 0.25, 0.25, 0.25 ,0.5]
}

all_synth_release = {
  "pizz" => [1, 1, 1, 0.25, 0.5, 1, 0.25, 0.5, 1, 0.25, 0.5],
  "piano" => [1, 2.5, 1, 0.5, 0.5, 0.5, 0.25, 0.75]
}

all_synth_amp = {
  "pizz" => [1, 1, 1, 1, 1.5, 1.5, 1, 1.5, 1.5, 1, 1.5],
  "piano" => [1.5, 1, 1.5, 1, 1.5, 1, 1.5, 1.5]
}

live_loop :pizz, sync: :met do
  use_synth :subpulse
  
  pizz_note = all_synth_note["pizz"].ring
  pizz_sleep = all_synth_sleep["pizz"].ring
  pizz_rel = all_synth_release["pizz"].ring
  pizz_amp = all_synth_amp["pizz"].ring
  
  11.times do
    play pizz_note.tick(:pizz_note), cutoff: 80, release: pizz_rel.tick(:pizz_release) , amp: amp_pizz * pizz_amp.tick(:pizz_amp)
    sleep pizz_sleep.tick(:pizz_sleep)
  end
  
end

live_loop :piano, sync: :met do
  use_synth :piano
  
  piano_note = all_synth_note["piano"].ring
  piano_sleep = all_synth_sleep["piano"].ring
  piano_rel = all_synth_release["piano"].ring
  piano_amp = all_synth_amp["piano"].ring
  
  11.times do
    play piano_note.tick(:piano_note), release: piano_rel.tick(:piano_rel), amp: amp_piano * piano_amp.tick(:piano_amp)
    sleep piano_sleep.tick(:piano_sleep)
  end
  
end

live_loop :piano_chord, sync: :met do
  use_synth :piano
  
  piano_chord_note = all_synth_note["piano_chord"].ring
  
  11.times do
    play piano_chord_note.tick(:piano_chord_note), sustain: 1.8, release: 0.5, amp: amp_piano
    sleep 2
  end
  
end

live_loop :piano_co, sync: :met do
  use_synth :piano
  piano_co_sleep = all_synth_sleep["piano_co"].ring
  6.times do
    play scale(:eb4, :major).choose, amp: amp_piano_co
    sleep piano_co_sleep.tick
  end
  
end


