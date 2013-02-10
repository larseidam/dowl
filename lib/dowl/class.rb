module DOWL
  
  class Class < DOWL::LabelledDocObject
    include Comparable
    
    attr_reader :resource
    
    def initialize(resource, schema)
      super(resource, schema)
    end
    
    def uri
      return @resource.to_s
    end
    
    def sub_class_of()
      parents = []

      @schema.model.query( 
        RDF::Query::Pattern.new( @resource, DOWL::Namespaces::RDFS.subClassOf ) ) do |statement|
        uri = statement.object.to_s
        if @schema.classes[uri]
          parents << @schema.classes[uri]
        else
          parents << uri
        end
      end
      return parents
    end
   
    def see_alsos()
       links = []
       @schema.model.query( 
         RDF::Query::Pattern.new( @resource, DOWL::Namespaces::RDFS.seeAlso ) ) do |statement|
         links << statement.object.to_s
       end
       return links
    end
    
    def to_s
      return short_name
    end
    
    def sub_classes()
      list = []
        
      @schema.model.query(
        RDF::Query::Pattern.new( nil, DOWL::Namespaces::RDFS.subClassOf, @resource) ) do |statement|
          list << DOWL::Class.new(statement.subject, @schema)
      end
      return list
    end
    
  end
  
  
end
