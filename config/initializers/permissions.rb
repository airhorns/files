#See https://github.com/hornairs/thwart
#Thwart.configure do
    #Add :create, :show, :update, and :destroy
    #Thwart::Actions.add_crud!
    #Set the default response
    #default_query_response false

    #action_group :manage, [:view, :create, :update, :destroy]

    #role :employee do
        #view :all
        #update :this, :that
    #end

    #role :manager, :include => :employee do
        #allow do
            #create :those, :if => Proc.new do |actor, resource, role|
                #return true if actor.id == resource.created_by
            #end
            #destroy :this
        #end
        #deny do
            #destroy :that
        #end
    #end

    #role :administrator do
        #manage :all
    #end
#end

