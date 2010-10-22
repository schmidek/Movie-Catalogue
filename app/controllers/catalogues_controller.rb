class CataloguesController < ApplicationController
  # GET /catalogues
  # GET /catalogues.xml
  def index
    @catalogues = Catalogue.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalogues }
    end
  end

  # GET /catalogues/1
  # GET /catalogues/1.xml
  def show
    @catalogue = Catalogue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @catalogue }
    end
  end

  # GET /catalogues/new
  # GET /catalogues/new.xml
  def new
    @catalogue = Catalogue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalogue }
    end
  end

  # GET /catalogues/1/edit
  def edit
    @catalogue = Catalogue.find(params[:id])
  end

  # POST /catalogues
  # POST /catalogues.xml
  def create
    @catalogue = Catalogue.new(params[:catalogue])

    respond_to do |format|
      if @catalogue.save
        format.html { redirect_to(@catalogue, :notice => 'Catalogue was successfully created.') }
        format.xml  { render :xml => @catalogue, :status => :created, :location => @catalogue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @catalogue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /catalogues/1
  # PUT /catalogues/1.xml
  def update
    @catalogue = Catalogue.find(params[:id])

    respond_to do |format|
      if @catalogue.update_attributes(params[:catalogue])
        format.html { redirect_to(@catalogue, :notice => 'Catalogue was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalogue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogues/1
  # DELETE /catalogues/1.xml
  def destroy
    @catalogue = Catalogue.find(params[:id])
    @catalogue.destroy

    respond_to do |format|
      format.html { redirect_to(catalogues_url) }
      format.xml  { head :ok }
    end
  end
end
