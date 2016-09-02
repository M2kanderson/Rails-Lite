require 'rulers'

class QuotesController < Rulers::Controller
  def a_quote
    render :a_quote, :noun => :winking
  end
  def exception
      raise "It's a bad one!"
  end

  def quote_1
    quote_1 = FileModel.find(1)
    # quote_1 = "hello"
    render :quote, :obj => quote_1
  end

  def index
    quotes = FileModel.find_all_by_submitter("Jesus")
    render :index, :quotes => quotes
  end

  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth a thousand pixels",
      "attribution" => "Me"
    }
    m = FileModel.create attrs
    render :quote, :obj => m
  end

  def update_quote
    attrs = {
      "submitter" => "Jesus",
      "attribution" => "God"
    }
    quote_1 = FileModel.find(1)

    obj = FileModel.update(quote_1, attrs)
    render :quote, :obj => quote_1
  end
end
