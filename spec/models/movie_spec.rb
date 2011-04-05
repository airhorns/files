require 'spec_helper'

def fixture_path_plus(*args)
  File.send(:join, [Rails.root, 'spec', 'fixtures', 'movies'].concat(args))
end

describe Movie do
  describe "helpers" do
    it "should parse filenames correctly" do
      names = {"Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8.avi" => "Battle Los Angeles 2011",
               "Source Code 2011 TS XViD DTRG - SAFCuk009.avi" => "Source Code 2011",
               "The Kings.Speech.2010.DVDSCR.XviD.AC3-NYDIC.avi" => "The Kings Speech 2010",
               "Going.The.Distance.DVDRip.XviD-DiAMOND.avi" => "Going The Distance",
               "Transformers.Revenge.of.the.Fallen.2009.1080p.BluRay.x264-WiKi.mkv" => "Transformers Revenge of the Fallen 2009",
               "V.for.Vendetta.2005.720p.HDDVD.x264-ESiR.mkv" => "V for Vendetta 2005",
               "Zombie.Strippers.UNRATED.DVDRip.XviD-BULLDOZER" => "Zombie Strippers",
               "zeitgeist.dvdrip.xvid.cd1-cultxvid.avi" => "zeitgeist",
               "Tropic Thunder TS Beovulf.Eng.XviD.avi" => "Tropic Thunder"}
      names.each do |from, to|
        Movie.get_title_from_filename(from).should == to
      end
    end
  end

  describe "identification" do
    use_vcr_cassette
    it "should search imdb for individual files" do
      n = "Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8"
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.id.should == "1217613"
      end
      Movie.identify(fixture_path_plus(n, "#{n}.avi"))
    end

    it "should find imdb urls for folders which have nfos" do
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.id.should == "1217613"
      end
      Movie.identify(fixture_path_plus('Battle.Los.Angeles.2011.R5.AC3-5.1.NEW.AUDIO.XViD.Hive-CM8')).should_not == false
    end

    it "should search imdb for the title for folders without nfos" do
      Movie.should_receive(:new_from_imdb) do |movie|
        movie.id.should == "0397643"
      end
      Movie.identify(fixture_path_plus('Source Code 2011 TS XViD DTRG - SAFCuk009')).should_not == false
    end
  end
end
