require 'spec_helper'

def fixture_path_plus(*args)
  File.send(:join, [Rails.root, 'spec', 'fixtures', 'movies'].concat(args))
end

describe Hash do
  it "should url encode params, despite extlib's insistence it shouldn't" do
    {:x => "y z"}.to_params.should == "x=y%20z"
  end
end

describe Movie do
  describe "helpers" do
    it "should guess qualities correctly" do
      names = {"Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8.avi" => "SD (R5)",
               "Source Code 2011 TS XViD DTRG - SAFCuk009.avi" => "SD (TS)",
               "The Kings.Speech.2010.DVDSCR.XviD.AC3-NYDIC.avi" => "SD (DVDSCR)",
               "Going.The.Distance.DVDRip.XviD-DiAMOND.avi" => "SD (DVDRIP)",
               "Transformers.Revenge.of.the.Fallen.2009.1080p.BluRay.x264-WiKi.mkv" => "Super HD (1080p)",
               "V.for.Vendetta.2005.720p.HDDVD.x264-ESiR.mkv" => "HD (720p)",
               "Zombie.Strippers.UNRATED.DVDRip.XviD-BULLDOZER" => "SD (DVDRIP)",
               "zeitgeist.dvdrip.xvid.cd1-cultxvid.avi" => "SD (DVDRIP)",
               "Tropic Thunder TS Beovulf.Eng.XviD.avi" => "SD (TS)"}
      names.each do |from, to|
        Movie.guess_quality(from).should == to
      end
    end
  end

  describe "identification" do
    use_vcr_cassette
    before :each do
      Movie.destroy
    end

    it "should search imdb for individual files" do
      n = "Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8"
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.imdb_id.should == "tt1217613"
      end
      Movie.identify(fixture_path_plus(n, "#{n}.avi"))
    end

    it "should find imdb urls for folders which have nfos" do
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.imdb_id.should == "tt1217613"
      end
      Movie.identify(fixture_path_plus('Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8')).should_not == false
    end

    it "should search imdb for the title for folders without nfos" do
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.imdb_id.should == "tt0945513"
      end
      Movie.identify(fixture_path_plus('Source Code 2011 TS XViD DTRG - SAFCuk009')).should_not == false
    end

    it "should pass a full featured movie object" do
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.imdb_id.should == "tt0945513"
        movie.rating.should be
      end
      Movie.identify(fixture_path_plus('Source Code 2011 TS XViD DTRG - SAFCuk009')).should_not == false
    end
  end
end
