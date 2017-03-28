class FounderDashboardChoresFilter extends React.Component {
  constructor(props) {
    super(props);

    this.dropdownStatuses = this.dropdownStatuses.bind(this);

    validStatuses = ['all', 'pending', 'submitted', 'complete', 'not_accepted', 'needs_improvement'];
  }

  dropdownStatuses() {
    return validStatuses.filter(function (status) {
      return status !== this.props.chosenStatus
    }, this);
  }

  dropdownLabel(status) {
    return {
      all: 'All Chores',
      pending: 'Pending',
      submitted: 'Submitted',
      complete: 'Complete',
      not_accepted: 'Not Accepted',
      needs_improvement: 'Needs Improvement'
    }[status];
  }

  render() {
    return (
      <div className="btn-group filter-targets-dropdown">
        <button className="btn btn-with-icon btn-ghost-primary btn-md text-xs-left filter-targets-dropdown__button dropdown-toggle" aria-expanded="false" aria-haspopup="true" data-toggle="dropdown" type="button">
          <span className="filter-targets-dropdown__icon">
            <i className="fa fa-filter"/>
          </span>
          <span className="p-r-1">
            {this.dropdownLabel(this.props.chosenStatus)}
          </span>
          <span className="pull-xs-right filter-targets-dropdown__arrow"></span>
        </button>
        <div className="dropdown-menu filter-targets-dropdown__menu">
          {
            this.dropdownStatuses().map( function (status) {
              return <FounderDashboardChoresFilterOption key={status} name={status}
                pickFilterCB={this.props.pickFilterCB} dropdownLabel={this.dropdownLabel}/>
            }, this)
          }
        </div>
      </div>
    );
  }
}