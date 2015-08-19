# Save the React UI using a mutable object to keep track of each instance
# and persist the UI after hot code pushes


listeners = {}
register = (f) ->
  id = Random.hexString(10)
  listeners[id] = f
  -> delete listeners[id]
dispatch = (x) ->
  for id, f of listeners
    f(x)

# Trigger all react instances to save
@saveReact = saveReact = dispatch
# Top-level React UI instance
@ReactInstance = ReactInstance = Meteor._reload.migrationData('react-ui') or {}
Meteor._reload.onMigrate 'react-ui', ->
  saveReact()
  return [true, ReactInstance]

# @childInstance(name) will create a child instance for you
# @initializeInstance(instance) is called onMount and whenever a new instance is
# received as props.
# @save() should return an object to be saved on the instance
@InstanceMixin =
  propTypes:
    instance: React.PropTypes.object.isRequired
  componentWillMount: ->
    @stopListener = register(@saveInstance)
    @initializeInstance?(@props.instance)
  componentWillReceiveProps: (nextProps) ->
    if @props.instance isnt nextProps.instance
      @initializeInstance?(nextProps.instance)
  saveInstance: ->
    instance = @save?() or {}
    # mutable copy over the instance so the api can seem immutable using @save()
    for k,v of instance
      @props.instance[k] = v
  componentWillUnmount: ->
    @stopListener()
    @saveInstance()
  childInstance: (name) ->
    @props.instance.childInstances = @props.instance.childInstances or {}
    childInstances = @props.instance.childInstances
    unless childInstances[name]
      childInstances[name] = {}
    return childInstances[name]
