require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def self.find_all_by(attribute, args)
        files = Dir["db/quotes/*.json"]
        files = files.map { |f| FileModel.new f}
        filtered_files = files.select { |f| f[attribute] == args}
      end
      
      def self.method_missing(method, *args)
        if method.to_s.start_with?("find_all_by_")
          attribute_string = method[("find_all_by_".length)..-1]
          self.find_all_by(attribute_string, args[0])
        end
      end

      def id
        @id
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        @cache ||= {}
        if(@cache[id])
          return @cache[id]
        else
          begin
            model = FileModel.new("db/quotes/#{id}.json")
            @cache[id] = model
            model
          rescue
            return nil
          end
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f}
      end

      # def self.find_all_by_submitter(submitter)
      #   files = Dir["db/quotes/*.json"]
      #   files = files.map { |f| FileModel.new f}
      #   filtered_files = files.select { |f| f["submitter"] == submitter}
      # end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""
        files = Dir["db/quotes/*.json"]
        names = files.map{|f| f.split("/")[-1]}
        highest = names.map{ |b| b[0...-5].to_i}.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<-TEMPLATE
          {
            "submitter": "#{hash["submitter"]}",
            "quote": "#{hash["quote"]}",
            "attribution": "#{hash["attribution"]}"
          }
          TEMPLATE
        end
        FileModel.new "db/quotes/#{id}.json"
      end

      def self.update(item, attrs)
        id = item.id
        hash = item
        hash["submitter"] = attrs["submitter"] || hash["submitter"]
        hash["quote"] = attrs["quote"] || hash["quote"]
        hash["attribution"] = attrs["attribution"] || hash["attribution"]
        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<-TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
          TEMPLATE
        end
        FileModel.new "db/quotes/#{id}.json"
      end

    end
  end
end
