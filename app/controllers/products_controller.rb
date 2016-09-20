class ProductsController < ApplicationController
  def index
    @sneakers = Sneaker.all
    sort_attribute = params[:sort]   # :price
    sort_order = params[:sort_order] # :price
    discount_level = params[:discount]
    search_term = params[:search_term]
    category = params[:category]

    if category
      # category_object = Category.find_by(name: category)
      # @sneakers = category_object.sneakers
      # # same as below

      @sneakers = Category.find_by(name: category).sneakers
    end

    if search_term
      fuzzy_search_term = "%#{search_term}%"
      @sneakers = @sneakers.where("model ILIKE ? OR make ILIKE ?", fuzzy_search_term, fuzzy_search_term)
    end

    if discount_level
      @sneakers = @sneakers.where("price < ?", discount_level)
    end

    if sort_attribute && sort_order
      @sneakers = @sneakers.order(sort_attribute => sort_order)
      # @sneakers = @sneakers.order({price: :desc})
    elsif sort_attribute
      @sneakers = @sneakers.order(sort_attribute)
    end
  end

  def new
  end

  def create
    @sneaker = Sneaker.create(make: params[:make],
                              model: params[:model],
                              description: params[:description],
                              price: params[:price],
                              sneaker_in_stock: params[:sneaker_in_stock], 
                              supplier_id: params[:supplier][:supplier_id])

    Image.create(url: params[:image], sneaker_id: @sneaker.id) if params[:image]

    flash[:success] = "New Item Sucessfully Created"
    redirect_to "/sneakers/#{@sneaker.id}"
  end

  def show
    @sneaker = Sneaker.find(params[:id])
    @categories = @sneaker.categories
    @supplier = @sneaker.supplier
  end

  def edit
    @sneaker = Sneaker.find(params[:id])
  end

  def update
    @sneaker = Sneaker.find(params[:id])
    @sneaker.update(make: params[:make],
                    model: params[:model],
                    description: params[:description],
                    price: params[:price],
                    sneaker_in_stock: params[:sneaker_in_stock],
                    supplier_id: params[:supplier_id])

    flash[:warning] = "Item Has Been Updated"
    redirect_to "/sneakers/#{@sneaker.id}"
  end

  def destroy
    @sneaker = Sneaker.find(params[:id])
    @sneaker.destroy

    flash[:danger] = "Item Has Been Deleted!"
    redirect_to "/sneakers"
  end

  def random
    random_product = Sneaker.all.sample

    redirect_to "/sneakers/#{random_product.id}"
  end
end
