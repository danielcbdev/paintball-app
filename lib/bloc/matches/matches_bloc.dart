import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:picospaintballzone/bloc/matches/matches_event.dart';
import 'package:picospaintballzone/bloc/matches/matches_state.dart';
import 'package:picospaintballzone/models/match/match.model.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class MatchesBloc extends HydratedBloc<MatchesEvent, MatchesState> {

  MatchModel? _currentMatch;
  MatchModel? get getMatchModel => _currentMatch;

  MatchesBloc() : super(InitialMatchesState()) {

    on<GetCurrentMatchEvent>((event, emit) async {
      try {
        emit(DoneGetCurrentMatchState(match: _currentMatch));
      } on MatchesException catch (e) {
        emit(ErrorMatchesState(message: e.message));
      } catch (e) {
        emit(ErrorMatchesState(message: e.toString()));
      }
    });
    on<AddPlayerInMatchEvent>((event, emit) async {
      try {
        _currentMatch ??= MatchModel(players: []);

        _currentMatch?.players?.add(
          Player(
            index: (_currentMatch?.players ?? []).length,
            name: event.name,
            recharges: [],
          ),
        );

        emit(DoneUpdateCurrentMatchState(match: _currentMatch));
      } on MatchesException catch (e) {
        emit(ErrorMatchesState(message: e.message));
      } catch (e) {
        emit(ErrorMatchesState(message: e.toString()));
      }
    });
    on<AddChargeEvent>((event, emit) async {
      try {
        _currentMatch?.players?.forEach((element) {
          if(element.index == event.indexUser){
            element.recharges?.add(event.chargeValue);
          }
        });
        emit(DoneUpdateCurrentMatchState(match: _currentMatch));
      } on MatchesException catch (e) {
        emit(ErrorMatchesState(message: e.message));
      } catch (e) {
        emit(ErrorMatchesState(message: e.toString()));
      }
    });
    on<AddIndividualValueEvent>((event, emit) async {
      try {
        _currentMatch ??= MatchModel(players: []);
        _currentMatch?.individualPrice = event.individualValue;
        emit(DoneUpdateCurrentMatchState(match: _currentMatch));
      } on MatchesException catch (e) {
        emit(ErrorMatchesState(message: e.message));
      } catch (e) {
        emit(ErrorMatchesState(message: e.toString()));
      }
    });
    on<ClearMathEventEvent>((event, emit) async {
      _currentMatch = null;
      await HydratedBloc.storage.clear();
      emit(DoneUpdateCurrentMatchState(match: _currentMatch));
    });
  }

  @override
  MatchesState? fromJson(Map<String, dynamic> json) {
    try {
      _currentMatch = MatchModel.fromJson(json);
      return DoneGetCurrentMatchState(match: _currentMatch);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(MatchesState state) {
    try{
      Map<String, dynamic>? json;
      if(state is DoneGetCurrentMatchState){
        _currentMatch = state.match;
        json = state.match?.toJson();
      }
      return json;
    } catch(_){
      return null;
    }
  }
}
